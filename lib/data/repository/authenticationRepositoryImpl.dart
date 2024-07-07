import 'package:injectable/injectable.dart';
import 'package:smart_clinic_for_psychiatry/data/datasourceContracts/AuthenticationDataSource.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/userModel/UserModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/repository/AuthenticationRepository.dart';

@Injectable(as: AuthenticationRepository)
class AuthenticationRepositoryImpl extends AuthenticationRepository {
  AuthenticationDataSource authenticationOnlineDataSource;

  @factoryMethod
  AuthenticationRepositoryImpl(this.authenticationOnlineDataSource);

  @override
  Future<MyUser?> register(
      String name,
      String email,
      String password,
      String passwordVerification,
      String phone,
      String role,
      ) {
    return authenticationOnlineDataSource.register(
        name, email, password, passwordVerification, phone, role);
  }

  @override
  Future<MyUser?> login(String email, String password) {
    return authenticationOnlineDataSource.login(email, password);
  }

  @override
  Future<MyUser?> logout() async {
    await authenticationOnlineDataSource.logout();
    return null;
  }

  @override
  Future<MyUser?> resetPassword(String email) async {
    await authenticationOnlineDataSource.resetPassword(email);
    return null;
  }
  @override
  Future<MyUser?> updateUserInfo(String newName, String newPhone) async {
    return authenticationOnlineDataSource.updateUserInfo(newName, newPhone);
  }

  @override
  Future<MyUser?> changePassword(String currentEmail, String currentPassword, String newPassword, String confirmPassword)async{
    return authenticationOnlineDataSource.changePassword(currentEmail, currentPassword,newPassword,confirmPassword);
  }


}
