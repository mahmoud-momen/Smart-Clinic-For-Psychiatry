import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/userModel/UserModel.dart';

abstract class AuthenticationRepository {
  Future<MyUser?> register(
      String name,
      String email,
      String password,
      String passwordVerification,
      String phone,
      String role
      );
  Future<MyUser?> login(String email, String password);
  Future<MyUser?> logout();
  Future<MyUser?> resetPassword(String email);
  Future<MyUser?> updateUserInfo(String newName, String newPhone);
  Future<MyUser?> changePassword(String currentEmail, String currentPassword, String newPassword, String confirmPassword);



}
