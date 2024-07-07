import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_clinic_for_psychiatry/data/database/firebase/FireBaseUtils.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/userModel/UserModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/usecase/ResetPasswordUseCase.dart';

@injectable
class ResetPasswordViewModel extends Cubit<ResetPasswordViewState> {
  var emailController = TextEditingController();

  ResetPasswordUseCase resetPasswordUseCase;

  @factoryMethod
  ResetPasswordViewModel(this.resetPasswordUseCase) : super(InitialState());

  void resetPassword() async {
    try {
      emit(LoadingState());
      bool emailExists = await FirebaseUtils.checkIfEmailExists(emailController.text);
      if (!emailExists) {
        emit(ErrorState('Email is not found!'));
        return;
      }
      var myUser = await resetPasswordUseCase.invoke(
        emailController.text,
      );
      if (myUser == null) {
        emit(ErrorState('We have sent you an email!'));
      } else {
        emit(ResetPasswordSuccessState(myUser));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}

sealed class ResetPasswordViewState {}

class InitialState extends ResetPasswordViewState {}

class ErrorState extends ResetPasswordViewState {
  String? message;
  ErrorState(this.message);
}

class LoadingState extends ResetPasswordViewState {}

class ResetPasswordSuccessState extends ResetPasswordViewState {
  MyUser myUser;
  ResetPasswordSuccessState(this.myUser);
}
