import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/di/di.dart';
import 'package:smart_clinic_for_psychiatry/presentation/authentication/loginScreen/LoginScreenViewModel.dart';
import 'package:smart_clinic_for_psychiatry/presentation/authentication/registerScreen/RegisterScreen.dart';
import 'package:smart_clinic_for_psychiatry/presentation/authentication/resetPasswordScreen/resetPasswordScreen.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/customTextFormField/CustomTextFormField.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/dialogUtils/dialogUtils.dart';
import 'package:smart_clinic_for_psychiatry/presentation/doctorSide/homeScreen/HomeScreen.dart';
import 'package:smart_clinic_for_psychiatry/presentation/patientSide/homeScreen/HomeScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var viewModel = getIt<LoginViewModel>();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return BlocListener<LoginViewModel, LoginViewState>(
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
              DialogUtils.showMessage(context, AppLocalizations.of(context)!.something_went_wrong,
                  posActionName: AppLocalizations.of(context)!.ok);
            }
          case LoadingState():
            {
              DialogUtils.showLoading(context, AppLocalizations.of(context)!.loading);
            }

          case LoginSuccessState():
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.of(context).pop(); // Close the dialog after 1 second
              final role = (state as LoginSuccessState).myUser.role;
              if (role == 'patient') {
                Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              } else if (role == 'doctor') {
                Navigator.pushReplacementNamed(
                    context, HomeScreenDoctor.routeName);
              } else {
                // Handle other roles or invalid roles
              }
            });
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.logged_in_successfully),
                  content: Text(
                    '${AppLocalizations.of(context)!.welcome_back} ${state.myUser.name}!',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              },
            );
            break;

          case InitialState():
        }
      },
      bloc: viewModel,
      child: Scaffold(
        backgroundColor: provider.isDarkMode()
            ? MyTheme.primaryDark
            : MyTheme.primaryLight,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 100.h,
                ),
                BounceInDown(
                  child: Text(AppLocalizations.of(context)!.sign_in,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MyTheme.whiteColor,
                    fontSize: 60,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ),
                SizedBox(
                  height: 70.h,
                ),
                FadeInLeft(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.welcome_back_to_smart_clinic_for_psychiatry,
                        style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: MyTheme.whiteColor),
                      ),
                      Text(
                        AppLocalizations.of(context)!.please_sign_in_with_your_email,
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
                BounceInUp(
                  child: CustomFormField(
                    label: AppLocalizations.of(context)!.email,
                    hint: AppLocalizations.of(context)!.enter_your_email,
                    controller: viewModel.emailController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return AppLocalizations.of(context)!.please_enter_a_valid_e_mail;
                      }
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0.9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(text);
                      if (!emailValid) {
                        return AppLocalizations.of(context)!.please_enter_a_valid_e_mail;
                      }
                      return null;
                    }, inputFormatters: [],
                  ),
                ),
                BounceInUp(
                  child: CustomFormField(
                    label: AppLocalizations.of(context)!.password,
                    hint: AppLocalizations.of(context)!.enter_your_password,
                    controller: viewModel.passwordController,
                    secureText: true,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return AppLocalizations.of(context)!.please_enter_a_valid_password;
                      }
                      if (text.length < 6) {
                        return AppLocalizations.of(context)!.password_should_be_at_least_six_characters;
                      }
                      return null;
                    }, inputFormatters: [],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                    AppLocalizations.of(context)!.dont_have_an_account,
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: MyTheme.whiteColor),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, RegisterScreen.routeName);
                      },
                      child: Text(
                          AppLocalizations.of(context)!.sign_up,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            decorationColor: MyTheme.whiteColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: MyTheme.whiteColor),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                    AppLocalizations.of(context)!.forgot_your_password,
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: MyTheme.whiteColor),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, ResetPasswordScreen.routeName);
                      },
                      child: Text(
                          AppLocalizations.of(context)!.reset_password,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            decorationColor: MyTheme.whiteColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: MyTheme.whiteColor),
                      ),
                    ),
                  ],
                ),
                BounceInUp(
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            MyTheme.backgroundButtonColor),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(vertical: 12),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        login();
                      },
                      child: Text(
                          AppLocalizations.of(context)!.sign_in,
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
    );
  }

  void login() {
    viewModel.login();
  }
}
