import 'package:injectable/injectable.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/userModel/UserModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/repository/AuthenticationRepository.dart';

@injectable
class ChangePasswordUseCase {
  AuthenticationRepository repository;

  @factoryMethod
  ChangePasswordUseCase(this.repository);

  Future<MyUser?> invoke(String currentEmail, String currentPassword, String newPassword, String confirmPassword) {
    return repository.changePassword(currentEmail, currentPassword, newPassword, confirmPassword);
  }
}