import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/userModel/UserModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/usecase/ChangePasswordUseCase.dart';

@injectable
class ChangePasswordViewModel extends Cubit<ChangePasswordViewState> {
  var currentEmailController = TextEditingController();
  var currentPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  ChangePasswordUseCase changePasswordUseCase;

  @factoryMethod
  ChangePasswordViewModel(this.changePasswordUseCase) : super(InitialState());

  void changePassword() async {
    try {
      emit(LoadingState());

      // Ensure passwords match before calling the use case
      if (newPasswordController.text != confirmPasswordController.text) {
        emit(ErrorState('New password and confirmation do not match.'));
        return;
      }

      var myUser = await changePasswordUseCase.invoke(
        currentEmailController.text,
        currentPasswordController.text,
        newPasswordController.text,
        confirmPasswordController.text,
      );

      if (myUser == null) {
        emit(ErrorState('Incorrect email or password.'));
      } else {
        emit(ChangePasswordSuccessState(myUser));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }



}

sealed class ChangePasswordViewState {}

class InitialState extends ChangePasswordViewState {}

class ErrorState extends ChangePasswordViewState {
  String? message;
  ErrorState(this.message);
}

class LoadingState extends ChangePasswordViewState {}

class ChangePasswordSuccessState extends ChangePasswordViewState {
  MyUser? myUser;
  ChangePasswordSuccessState(this.myUser);
}