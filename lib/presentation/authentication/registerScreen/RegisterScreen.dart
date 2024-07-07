import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/di/di.dart';
import 'package:smart_clinic_for_psychiatry/presentation/authentication/loginScreen/LoginScreen.dart';
import 'package:smart_clinic_for_psychiatry/presentation/authentication/registerScreen/RegisterScreenViewModel.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/customTextFormField/CustomTextFormField.dart';
import 'package:animate_do/animate_do.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/dialogUtils/dialogUtils.dart';
import 'package:smart_clinic_for_psychiatry/presentation/userRoleScreen/UserRoleScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register screen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var viewModel = getIt<RegisterViewModel>();

  var formKey = GlobalKey<FormState>();

  late String chooseRoleButtonText = AppLocalizations.of(context)!
      .choose_role; // Initializing chooseRoleButtonText

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return BlocListener<RegisterViewModel, RegisterViewState>(
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
            DialogUtils.showMessage(
                context, AppLocalizations.of(context)!.something_went_wrong,
                posActionName: AppLocalizations.of(context)!.ok);
            break;
          case LoadingState():
            DialogUtils.showLoading(
                context, AppLocalizations.of(context)!.loading);
            break;
          case RegisterSuccessState():
            // Show success message for 1 second, then navigate automatically
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            });
            DialogUtils.showMessage(
                context, AppLocalizations.of(context)!.registered_successfully);
            break;
          case InitialState():
            break;
        }
      },
      bloc: viewModel,
      child: Scaffold(
        backgroundColor:
            provider.isDarkMode() ? MyTheme.primaryDark : MyTheme.primaryLight,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 70.h,
                  ),
                  BounceInDown(
                    child: Text(
                      AppLocalizations.of(context)!.sign_up,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyTheme.whiteColor,
                          fontSize: 60,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  FadeInLeft(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .welcome_to_our_vibrant_community_of_smart_clinic_for_psychiatry,
                          style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              color: MyTheme.whiteColor),
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .feel_free_to_sign_up_and_join_us_on_our_exciting_journey,
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w300,
                              color: MyTheme.whiteColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  BounceInLeft(
                    child: CustomFormField(
                      label: AppLocalizations.of(context)!.full_name,
                      hint: AppLocalizations.of(context)!.full_name,
                      controller: viewModel.nameController,
                      keyboardType: TextInputType.name,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_a_valid_username;
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(
                            r'[a-zA-Z\s]')), // Allow only alphabetic characters and spaces
                      ],
                    ),
                  ),
                  BounceInLeft(
                    child: CustomFormField(
                      label: AppLocalizations.of(context)!.email,
                      hint: AppLocalizations.of(context)!.email,
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_a_valid_e_mail;
                        }
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text);
                        if (!emailValid) {
                          return AppLocalizations.of(context)!
                              .please_enter_a_valid_e_mail;
                        }
                        return null;
                      },
                      inputFormatters: [],
                    ),
                  ),
                  BounceInLeft(
                    child: CustomFormField(
                      label: AppLocalizations.of(context)!.phone_numbers,
                      hint: AppLocalizations.of(context)!.phone_numbers,
                      controller: viewModel.phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            11), // Limit to 11 characters
                        FilteringTextInputFormatter
                            .digitsOnly, // Allow only digits
                      ],
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_a_valid_phone_number;
                        }
                        if (text.length != 11) {
                          return AppLocalizations.of(context)!
                              .please_enter_a_valid_phone_number;
                        }
                        if (!(text.startsWith('010') ||
                            text.startsWith('011') ||
                            text.startsWith('012') ||
                            text.startsWith('015'))) {
                          return AppLocalizations.of(context)!
                              .please_enter_a_valid_phone_number;
                        }
                        return null;
                      },
                    ),
                  ),
                  BounceInLeft(
                    child: CustomFormField(
                      label: AppLocalizations.of(context)!.password,
                      hint: AppLocalizations.of(context)!.password,
                      controller: viewModel.passwordController,
                      keyboardType: TextInputType.text,
                      secureText: true,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!.please_enter_a_valid_password;
                        }
                        if (text.length < 6) {
                          return AppLocalizations.of(context)!.password_should_be_at_least_six_characters;
                        }
                        bool hasUppercase = text.contains(RegExp(r'[A-Z]'));
                        bool hasSpecialCharacter = text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
                        if (!hasUppercase) {
                          return AppLocalizations.of(context)!.password_should_have_uppercase;
                        }
                        if (!hasSpecialCharacter) {
                          return AppLocalizations.of(context)!.password_should_have_special_character;
                        }
                        return null;
                      },
                      inputFormatters: [],
                    ),
                  ),

                  BounceInLeft(
                    child: CustomFormField(
                      label:
                          AppLocalizations.of(context)!.password_verification,
                      hint: AppLocalizations.of(context)!.confirm_password,
                      controller: viewModel.passwordVerificationController,
                      keyboardType: TextInputType.text,
                      secureText: true,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return AppLocalizations.of(context)!
                              .please_enter_a_confirmation_password;
                        }
                        if (text != viewModel.passwordController.text) {
                          return AppLocalizations.of(context)!
                              .password_does_not_match;
                        }
                        return null;
                      },
                      inputFormatters: [],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.already_have_an_account,
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: MyTheme.whiteColor),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.sign_in,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                              decorationColor: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: MyTheme.whiteColor),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          MyTheme.backgroundButtonColor),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            vertical: 15), // Adjust padding
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, UserRoleScreen.routeName)
                          .then((value) {
                        if (value != null) {
                          String buttonText =
                              value == AppLocalizations.of(context)!.doctor
                                  ? AppLocalizations.of(context)!.doctor
                                  : AppLocalizations.of(context)!.patient;
                          setState(() {
                            viewModel.roleController.text =
                                value.toString(); // Explicit cast to string
                            chooseRoleButtonText = buttonText;
                          });
                        }
                      });
                    },
                    child: Text(
                      chooseRoleButtonText, // Default text if not set
                      style: TextStyle(
                        color: provider.isDarkMode()
                            ? MyTheme.primaryDark
                            : MyTheme.primaryLight,
                        fontSize: 24,
                        fontWeight: FontWeight.w600, // Adjust font size
                      ),
                    ),
                  ),
                  BounceInUp(
                    child: Padding(
                      padding: const EdgeInsets.all(50),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              MyTheme.backgroundButtonColor),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(vertical: 12),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          createAccount();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.sign_up,
                          style: TextStyle(
                            color: provider.isDarkMode()
                                ? MyTheme.primaryDark
                                : MyTheme.primaryLight,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createAccount() {
    // Check if the role is not chosen
    if (viewModel.roleController.text.isEmpty) {
      // Show a message or handle the scenario where the role is not chosen
      DialogUtils.showMessage(
        context,
        AppLocalizations.of(context)!.please_complete_the_missing_fields,
        posActionName: AppLocalizations.of(context)!.ok,
      );
      return; // Exit the method early
    }

    // Check if the full name field is empty or contains only whitespace
    if (viewModel.nameController.text.trim().isEmpty) {
      DialogUtils.showMessage(
        context,
        AppLocalizations.of(context)!.please_complete_the_missing_fields,
        posActionName: AppLocalizations.of(context)!.ok,
      );
      return; // Exit the method early
    }

    // Check if the form is valid
    if (formKey.currentState?.validate() == false) return;

    // If the role is chosen and the form is valid, proceed with creating the account
    viewModel.createAccount();
  }
}
