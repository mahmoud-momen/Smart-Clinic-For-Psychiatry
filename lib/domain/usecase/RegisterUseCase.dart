import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/userModel/UserModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/repository/AuthenticationRepository.dart';

@injectable
class RegisterUseCase{
  AuthenticationRepository repository;
  @factoryMethod RegisterUseCase(this.repository);

  Future<MyUser?> invoke( String name,
      String email,
      String password,
      String passwordVerification,
      String phone,
      String role,

      ){
    return repository.register(name, email, password,
        passwordVerification, phone, role);
  }
}
