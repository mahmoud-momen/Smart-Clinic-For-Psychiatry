import 'package:injectable/injectable.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/userModel/UserModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/repository/AuthenticationRepository.dart';

@injectable
class EditProfileUseCase {
  AuthenticationRepository repository;

  @factoryMethod
  EditProfileUseCase(this.repository);

  Future<MyUser?> invoke(String newName, String newPhone) {
    return repository.updateUserInfo(newName, newPhone);
  }
}
