import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:smart_clinic_for_psychiatry/domain/model/userModel/UserModel.dart';
import 'package:smart_clinic_for_psychiatry/domain/usecase/EditProfileUseCase.dart';

@injectable
class EditProfileViewModel extends Cubit<EditProfileViewState> {
  final EditProfileUseCase editProfileUseCase;
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var newNameController = TextEditingController();
  var newPhoneController = TextEditingController();
  var selectedPicturePath = '';

  EditProfileViewModel(this.editProfileUseCase) : super(InitialState());

  void updateUserInfo() async {
    try {
      emit(LoadingState());

      // Get the original name and phone number from the view model
      final originalName = nameController.text;
      final originalPhone = phoneController.text;

      // Use ternary operators to conditionally update name and phone based on user input
      final updatedName = newNameController.text.isEmpty
          ? originalName
          : newNameController.text;
      final updatedPhone = newPhoneController.text.isEmpty
          ? originalPhone
          : newPhoneController.text;

      final MyUser = await editProfileUseCase.invoke(updatedName, updatedPhone);

      if (MyUser == null) {
        emit(ErrorState('Failed to update user information'));
      } else {
        // Update controllers with new values
        nameController.text = updatedName;
        phoneController.text = updatedPhone;

        emit(EditProfileSuccessState(MyUser));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}

// Define the states
sealed class EditProfileViewState {}

class InitialState extends EditProfileViewState {}

class ErrorState extends EditProfileViewState {
  final String message;

  ErrorState(this.message);
}

class LoadingState extends EditProfileViewState {}

class EditProfileSuccessState extends EditProfileViewState {
  MyUser? myUser;

  EditProfileSuccessState(this.myUser);
}
