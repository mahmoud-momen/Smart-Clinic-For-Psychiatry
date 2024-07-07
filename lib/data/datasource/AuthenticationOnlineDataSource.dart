import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_clinic_for_psychiatry/data/database/firebase/FireBaseUtils.dart';
import 'package:smart_clinic_for_psychiatry/data/datasourceContracts/AuthenticationDataSource.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/userModel/UserModel.dart';

@Injectable(as: AuthenticationDataSource)
class AuthenticationOnlineDataSource extends AuthenticationDataSource {
  FirebaseUtils firebaseUtils;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @factoryMethod
  AuthenticationOnlineDataSource(this.firebaseUtils);

  @override
  Future<MyUser?> register(String name, String email, String password,
      String passwordVerification, String phone, String role) async {
    try {
      // Check if passwords match
      if (password != passwordVerification) {
        throw Exception("Passwords do not match");
      }

      // Create user in Firebase Authentication
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create a complete user data map
      final userData = {
        'uid': credential.user!.uid,
        'email': email,
        'name': name,
        'phone': phone,
        'role': role,
      };

      // Save complete user data to Firestore using FirebaseUtils or directly
      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(userData);

      // Create MyUser object with the provided information
      MyUser myUser = MyUser(
          id: credential.user?.uid ?? '',
          name: name,
          email: email,
          phone: phone,
          role: role);

      return myUser; // Return the created user object
    } catch (e) {
      print("Error registering user: $e");
      return null;
    }
  }

  @override
  Future<MyUser?> login(String email, String password) async {
    try {
      // Sign in with email and password
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Retrieve user data from Firestore using FirebaseUtils or directly
      final userData = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userData.exists) {
        return null; // Login failed if user data not found
      }

      final userMap = userData.data() as Map<String, dynamic>;

      // Check if all fields are present and assign empty strings if missing
      final name = userMap['name'] ?? '';
      final phone = userMap['phone'] ?? '';
      final role = userMap['role'] ?? '';

      // Create MyUser object with retrieved or default values
      MyUser user = MyUser(
          id: userMap['uid'],
          name: name,
          email: userMap['email'],
          phone: phone,
          role: role);

      return user;
    } catch (e) {
      print("Error logging in: $e");
      return null;
    }
  }
  @override
  Future<MyUser?> logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out the user
    } catch (e) {
      print("Error logging out: $e");
    }
    return null;
  }

  @override
  Future<MyUser?> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error resetting password: $e");
    }
    return null;
  }

  @override
  Future<MyUser?> updateUserInfo(String newName, String newPhone) async {
    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      // Create an update map with only the changed fields
      final updateMap = <String, String>{};
      if (newName.isNotEmpty) {
        updateMap['name'] = newName;
      }
      if (newPhone.isNotEmpty) {
        updateMap['phone'] = newPhone;
      }

      // Check if any update is needed
      if (updateMap.isEmpty) {
        // No changes, return the current user without update
        final retrievedUser =
        await FirebaseUtils.readUserFromFireStore(user.uid);
        return retrievedUser;
      }

      // Update user information in Firestore
      final docRef = FirebaseFirestore.instance
          .collection(MyUser.collectionName)
          .doc(user.uid);
      await docRef.update(updateMap);

      // Retrieve and return the updated user object
      final retrievedUser = await FirebaseUtils.readUserFromFireStore(user.uid);

      // Handle the case where retrievedUser is null
      if (retrievedUser == null) {
        // Implement your desired behavior (e.g., log an error, return null)
        print("Error retrieving updated user data");
        return null;
      } else {
        return retrievedUser;
      }
    } catch (e) {
      print("Error updating user info: $e");
      return null;
    }
  }


  @override
  Future<MyUser?> changePassword(String currentEmail, String currentPassword,
      String newPassword, String confirmPassword) async {
    try {
      // Check if newPassword matches confirmPassword
      if (newPassword != confirmPassword) {
        throw Exception("New password and confirmation do not match.");
      }

      // Get the user object
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in.");
      }

      // Re-authenticate the user with their current email and password
      final credential = EmailAuthProvider.credential(
          email: currentEmail, password: currentPassword);
      await user.reauthenticateWithCredential(credential);

      // Update the password on Firebase Authentication
      await user.updatePassword(newPassword);

      // Retrieve user data to return
      return await FirebaseUtils.readUserFromFireStore(user.uid);
    } catch (e) {
      print("Error changing password: $e");
      return null;
    }
  }

}
