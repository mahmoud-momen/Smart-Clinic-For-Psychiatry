import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/userModel/UserModel.dart';

@injectable
@singleton
class FirebaseUtils {
  static CollectionReference<MyUser> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
        fromFirestore: (snapshot, options) =>
            MyUser.fromFireStore(snapshot.data()),
        toFirestore: (user, options) => user.toFireStore());
  }

  static Future<void> addUserToFireStore(MyUser myUser) {
    return getUsersCollection().doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> readUserFromFireStore(String uId) async {
    var querySnapshot = await getUsersCollection().doc(uId).get();
    return querySnapshot.data();
  }

  static Future<bool> checkIfEmailExists(String email) async {
    var querySnapshot = await getUsersCollection()
        .where('email', isEqualTo: email)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  static Future<String?> getUserName(String uId) async {
    final user = await readUserFromFireStore(uId);
    if (user != null) {
      return user.name;
    } else {
      return null;
    }
  }

  static Future<String?> getPhone(String uId) async {
    final phone = await readUserFromFireStore(uId);
    if (phone != null) {
      return phone.phone;
    } else {
      return null;
    }
  }

  static Future<void> updateUserProfileImage(
      String uId, String imageUrl) async {
    await getUsersCollection().doc(uId).update({'imageUrl': imageUrl});
  }

  static Future<String?> getUserProfileImage(String uId) async {
    final imageUrl = await readUserFromFireStore(uId);
    if (imageUrl != null) {
      return imageUrl.imageUrl;
    } else {
      return null;
    }
  }
}
