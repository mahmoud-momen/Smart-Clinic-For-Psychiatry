import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/userModel/UserModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/usecase/RegisterUseCase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@injectable
class RegisterViewModel extends Cubit<RegisterViewState> {
  RegisterUseCase registerUseCase;


  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var phoneController = TextEditingController();

  var passwordController = TextEditingController();

  var passwordVerificationController = TextEditingController();

  var roleController = TextEditingController();


  @factoryMethod
  RegisterViewModel(this.registerUseCase) : super(InitialState());

  void createAccount() async {

    try {
      emit(LoadingState());
      var MyUser = await registerUseCase.invoke(
          nameController.text,
          emailController.text,
          passwordController.text,
          passwordVerificationController.text,
          phoneController.text,
          roleController.text,
      );

      emit(RegisterSuccessState(MyUser));
    } catch (e) {
      emit(ErrorState('Something went wrong'));
    }
  }

}

sealed class RegisterViewState {}

class InitialState extends RegisterViewState {}

class ErrorState extends RegisterViewState {
  String? message;
  ErrorState(this.message);
}

class LoadingState extends RegisterViewState {}

class RegisterSuccessState extends RegisterViewState {

  MyUser? myUser;
  RegisterSuccessState(this.myUser);
}
