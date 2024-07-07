import 'package:injectable/injectable.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/userModel/UserModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/repository/AuthenticationRepository.dart';

@injectable
class ResetPasswordUseCase {
  AuthenticationRepository repository;

  @factoryMethod ResetPasswordUseCase(this.repository);

  Future<MyUser?> invoke(String email) async {
    await repository.resetPassword(email);
    return null;
  }
}
