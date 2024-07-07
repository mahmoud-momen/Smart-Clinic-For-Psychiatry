import 'package:injectable/injectable.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/userModel/UserModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/repository/AuthenticationRepository.dart';

@injectable
class LogoutUseCase {
  AuthenticationRepository repository;

  @factoryMethod LogoutUseCase(this.repository);

  Future<MyUser?> invoke() async {
    await repository.logout();
    return null;
  }
}
