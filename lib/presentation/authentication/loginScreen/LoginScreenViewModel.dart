import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/userModel/UserModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/usecase/LoginUseCase.dart';

@injectable
class LoginViewModel extends Cubit<LoginViewState>{
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  LoginUseCase loginUseCase;
  @factoryMethod LoginViewModel(this.loginUseCase):super(InitialState());



  void login() async {
    try {
      emit(LoadingState());
      var MyUser = await loginUseCase.invoke(
        emailController.text,
        passwordController.text,
      );
      if(MyUser == null){
        emit(ErrorState('Something went wrong'));
      }
      else {
        emit(LoginSuccessState(MyUser));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}


sealed class LoginViewState{}
class InitialState extends LoginViewState{}
class ErrorState extends LoginViewState {
  String? message;
  ErrorState(this.message);
}

class LoadingState extends LoginViewState {}

class LoginSuccessState extends LoginViewState {
  MyUser myUser;
  LoginSuccessState(this.myUser);
}
