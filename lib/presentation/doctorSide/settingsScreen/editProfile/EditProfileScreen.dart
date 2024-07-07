import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/data/database/firebase/FireBaseUtils.dart';
import 'package:smart_clinic_for_psychiatry/di/di.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/dialogUtils/dialogUtils.dart';
import 'package:smart_clinic_for_psychiatry/presentation/doctorSide/settingsScreen/editProfile/EditProfileViewModel.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/imageProfile/ImageFunctions.dart';
import 'package:smart_clinic_for_psychiatry/presentation/doctorSide/settingsScreen/editProfile/changePassword/ChangePasswordScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';


class EditProfileScreen extends StatefulWidget {
  static const String routeName = 'edit profile doctor';
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? pickedImage;
  var viewModel = getIt<EditProfileViewModel>();
  String? userName;
  String? userPhone;
  String? _userPicture;
  bool editingProfile = false;
  bool showSuccessMessage = false;

  @override
  void initState() {
    super.initState();
    _getUserName();
    _getPhone();
    _getUserPicture();
  }

  Future<void> _getUserPicture() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user signed in');
      return; // Handle the case where no user is signed in
    }

    final String uId = user.uid; // Use actual logic to get ID

    final picture = await FirebaseUtils.getUserProfileImage(uId);
    setState(() {
      _userPicture = picture;
      print('Retrieved picture: $_userPicture'); // Log the retrieved picture
    });
  }

  Future<void> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user signed in');
      return;
    }
    final String uId = user.uid;
    final name = await FirebaseUtils.getUserName(uId);
    setState(() {
      userName = name;
      print('Retrieved name: $userName'); // Log the retrieved name
    });
  }

  Future<void> _getPhone() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user signed in');
      return;
    }
    final String uId = user.uid;
    final phone = await FirebaseUtils.getPhone(uId);
    setState(() {
      userPhone = phone;
      print('Retrieved phone: $userPhone');
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return BlocListener<EditProfileViewModel, EditProfileViewState>(
      listenWhen: (old, newState) {
        if (old is LoadingState && newState is! LoadingState) {
          DialogUtils.hideLoading(context);
        }
        if (newState is InitialState) return false;
        return true;
      },
      listener: (context, state) {
        switch (state) {
          case ErrorState():
            {
              DialogUtils.showMessage(context, state.message ?? "",
                  posActionName: 'Ok');
            }
          case LoadingState():
            {
              DialogUtils.showLoading(context, 'Loading..');
            }
          case EditProfileSuccessState():
            {
              setState(() {
                showSuccessMessage = true;
              });
              Future.delayed(const Duration(milliseconds: 2000), () {
                setState(() {
                  showSuccessMessage = false;
                });
              });

              // Fetch updated user information from Firebase
              _getUserName();
              _getPhone();
              _getUserPicture(); // Refresh profile image
              break;
            }
          case InitialState():
        }
      },
      bloc: viewModel,
      child: Scaffold(
        body: Stack(
          children: [
            provider.isDarkMode()
                ? Image.asset(
              'assets/images/settings_page_dark.png',
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            )
                : Image.asset(
              'assets/images/settings_page.png',
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60.h,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: MyTheme.whiteColor,
                          size: 40,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(width: 60.w),
                      Text(
                        AppLocalizations.of(context)!.edit_profile,
                        style: TextStyle(
                            color: MyTheme.whiteColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  InkWell(
                    onTap: () async {
                      if (editingProfile) {
                        File? temp = await ImageFunctions.galleryPicker();
                        if (temp != null) {
                          // Upload the selected image to Firebase Storage
                          String? imageUrl =
                          await ImageFunctions.uploadImageToFirebaseStorage(
                              temp);
                          if (imageUrl != null) {
                            setState(() {
                              pickedImage = temp;
                            });
                          } else {
                            print("Error uploading image to Firebase Storage.");
                          }
                        }
                      }
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 80.r,
                          backgroundImage: _userPicture == null
                              ? null
                              : NetworkImage(_userPicture!),
                          child: _userPicture == null
                              ? const Icon(
                            Icons.person,
                            size: 80,
                          )
                              : null,
                        ),
                        if (editingProfile)
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: CircleAvatar(
                              radius: 15,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/edit_profile_icon.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 35,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(AppLocalizations.of(context)!.full_name,
                            style: TextStyle(
                              color: provider.isDarkMode()
                                  ? MyTheme.whiteColor
                                  : MyTheme.primaryDark,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Container(
                        width: 350.w,
                        height: 55.h,
                        child: editingProfile
                            ? TextFormField(
                          style: TextStyle(
                            color: provider.isDarkMode()
                                ? MyTheme.whiteColor
                                : MyTheme.primaryDark,
                          ),
                          controller: viewModel.newNameController,
                          textAlign: TextAlign.start,
                          cursorHeight: 28.h,
                          cursorWidth: 1,
                          cursorColor: const Color(0xff3660D9),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z ]")),
                            LengthLimitingTextInputFormatter(32),
                          ],
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: provider.isDarkMode()
                                  ? MyTheme.whiteColor
                                  : MyTheme.primaryDark,
                            ),
                            hintText:
                            AppLocalizations.of(context)!.full_name,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xff3660D9)),
                            ),
                          ),
                        )
                            : Container(
                          padding:
                          const EdgeInsets.only(left: 10, top: 7),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Colors.grey
                                  .shade400, // You can set the color of the border here
                              width:
                              1.0, // You can adjust the width of the border here
                            ),
                          ),
                          child: Text(
                            userName ?? '',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 35,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(AppLocalizations.of(context)!.phone_numbers,
                            style: TextStyle(
                              color: provider.isDarkMode()
                                  ? MyTheme.whiteColor
                                  : MyTheme.primaryDark,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Container(
                        width: 350.w,
                        height: 55.h,
                        child: editingProfile
                            ? TextFormField(
                          style: TextStyle(
                            color: provider.isDarkMode()
                                ? MyTheme.whiteColor
                                : MyTheme.primaryDark,
                          ),
                          controller: viewModel.newPhoneController,
                          textAlign: TextAlign.start,
                          cursorHeight: 28.h,
                          cursorWidth: 1,
                          cursorColor: const Color(0xff3660D9),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[0-9]")),
                            LengthLimitingTextInputFormatter(11),
                            FilteringTextInputFormatter.deny(
                                RegExp(r'[^0-9]')),
                          ],
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: provider.isDarkMode()
                                  ? MyTheme.whiteColor
                                  : MyTheme.primaryDark,
                            ),
                            hintText: AppLocalizations.of(context)!
                                .phone_numbers,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xff3660D9)),
                            ),
                          ),
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                !['010', '011', '012', '015']
                                    .contains(value.substring(0, 3))) {
                              return 'Phone number must start with 010, 011, 012, or 015';
                            }
                            return null;
                          },
                        )
                            : Container(
                          padding:
                          const EdgeInsets.only(left: 10, top: 7),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Colors.grey
                                  .shade400, // You can set the color of the border here
                              width:
                              1.0, // You can adjust the width of the border here
                            ),
                          ),
                          child: Text(
                            userPhone ?? '',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChangePassword(),
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.change_password,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationThickness: 1,
                                decorationColor: provider.isDarkMode()
                                    ? MyTheme.whiteColor
                                    : MyTheme.primaryDark,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: provider.isDarkMode()
                                    ? MyTheme.whiteColor
                                    : MyTheme.primaryDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (editingProfile) {
                        // Save changes and toggle back to view mode
                        updateUserInfo();
                        setState(() {
                          editingProfile = false;
                        });
                      } else {
                        // Toggle to editing mode
                        setState(() {
                          editingProfile = true;
                          // Initialize controllers with current values
                          viewModel.newNameController.text = userName ?? '';
                          viewModel.newPhoneController.text = userPhone ?? '';
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      editingProfile ? Colors.green : MyTheme.primaryLight,
                      elevation: 8,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      editingProfile
                          ? AppLocalizations.of(context)!.save_changes
                          : AppLocalizations.of(context)!.edit_profile,
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Show success message
                  if (showSuccessMessage)
                    AnimatedOpacity(
                      opacity: showSuccessMessage ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Profile updated successfully',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateUserInfo() {
    if (viewModel.newNameController.text.trim().isEmpty) {
      viewModel.newNameController.text = userName ?? '';
    }
    if (viewModel.newPhoneController.text.trim().isEmpty) {
      viewModel.newPhoneController.text = userPhone ?? '';
    }

    viewModel.updateUserInfo();
  }
}


