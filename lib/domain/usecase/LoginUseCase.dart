
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/userModel/UserModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/repository/AuthenticationRepository.dart';

@injectable
class LoginUseCase{
  AuthenticationRepository repository;
  @factoryMethod LoginUseCase(this.repository);

  Future<MyUser?>invoke(String email, String password){
    return repository.login(email, password);
  }
}
