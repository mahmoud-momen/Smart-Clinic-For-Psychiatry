import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/di/di.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/dialogUtils/dialogUtils.dart';
import 'package:smart_clinic_for_psychiatry/presentation/patientSide/settingsScreen/editProfile/changePassword/ChangePasswordViewModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final viewModel = getIt<ChangePasswordViewModel>();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();

  final _currentPasswordFocusNode = FocusNode();
  final _newPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    viewModel.currentPasswordController.addListener(_validateCurrentPassword);
    viewModel.newPasswordController.addListener(_validateNewPassword);
    viewModel.confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    viewModel.currentPasswordController.removeListener(_validateCurrentPassword);
    viewModel.newPasswordController.removeListener(_validateNewPassword);
    viewModel.confirmPasswordController.removeListener(_validateConfirmPassword);
    _currentPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _validateCurrentPassword() {
    final value = viewModel.currentPasswordController.text;
    setState(() {
      if (value.isEmpty || value.length < 6) {
        _currentPasswordError = AppLocalizations.of(context)!.please_enter_a_valid_password;
      } else if (!RegExp(r'^(?=.*[A-Z])(?=.*\W)[A-Za-z\d\W]{6,}$').hasMatch(value)) {
        _currentPasswordError = AppLocalizations.of(context)!.please_enter_a_valid_password;
      } else {
        _currentPasswordError = null;
      }
    });
  }

  void _validateNewPassword() {
    final value = viewModel.newPasswordController.text;
    setState(() {
      if (value.isEmpty || value.length < 6) {
        _newPasswordError = AppLocalizations.of(context)!.please_enter_a_valid_password;
      } else if (!RegExp(r'^(?=.*[A-Z])(?=.*\W)[A-Za-z\d\W]{6,}$').hasMatch(value)) {
        _newPasswordError = AppLocalizations.of(context)!.please_enter_a_valid_password;
      } else {
        _newPasswordError = null;
      }
    });
  }

  void _validateConfirmPassword() {
    final value = viewModel.confirmPasswordController.text;
    setState(() {
      if (value.isEmpty || value.length < 6) {
        _confirmPasswordError = AppLocalizations.of(context)!.please_enter_a_valid_password;
      } else if (value != viewModel.newPasswordController.text) {
        _confirmPasswordError = AppLocalizations.of(context)!.password_does_not_match;
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return BlocListener<ChangePasswordViewModel, ChangePasswordViewState>(
      listenWhen: (old, newState) =>
      old is LoadingState || newState is! LoadingState,
      listener: (context, state) {
        switch (state.runtimeType) {
          case ErrorState:
            final errorState = state as ErrorState;
            DialogUtils.showMessage(
                context,
                errorState.message ??
                    AppLocalizations.of(context)!.something_went_wrong,
                posActionName: AppLocalizations.of(context)!.ok);
            break;
          case LoadingState:
            DialogUtils.showLoading(
                context, AppLocalizations.of(context)!.loading);
            break;
          case ChangePasswordSuccessState:
            DialogUtils.showMessage(context,
                AppLocalizations.of(context)!.password_changed_successfully);
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pop(context); // Navigate to the previous page
            });
            break;
          case InitialState:
            break;
        }
      },
      bloc: viewModel,
      child: Scaffold(
        backgroundColor:
        provider.isDarkMode() ? MyTheme.primaryDark : MyTheme.whiteColor,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 100.h),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: MyTheme.primaryLight, size: 40),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: 40.w),
                    Text(
                      AppLocalizations.of(context)!.change_password,
                      style: TextStyle(
                        color: MyTheme.primaryLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.h),
                Column(
                  children: [
                    buildEmailTextField(provider),
                    buildPasswordTextField(
                        AppLocalizations.of(context)!.current_password,
                        viewModel.currentPasswordController,
                        _obscureCurrentPassword,
                        _currentPasswordError, () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    }),
                    buildPasswordTextField(
                        AppLocalizations.of(context)!.new_password,
                        viewModel.newPasswordController,
                        _obscureNewPassword, _newPasswordError, () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    }),
                    buildPasswordTextField(
                        AppLocalizations.of(context)!.confirm_new_password,
                        viewModel.confirmPasswordController,
                        _obscureConfirmPassword, _confirmPasswordError, () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    }),
                  ],
                ),
                SizedBox(height: 40.h),
                ElevatedButton(
                  onPressed: changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyTheme.primaryLight,
                    elevation: 8,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.save_changes,
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.white,
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

  Widget buildEmailTextField(AppConfigProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text(AppLocalizations.of(context)!.email,
              style: TextStyle(
                fontSize: 17,
                color: provider.isDarkMode()
                    ? MyTheme.whiteColor
                    : MyTheme.primaryDark,
                fontWeight: FontWeight.bold,
              )),
        ),
        SizedBox(
          width: 350.w,
          height: 50.h,
          child: TextFormField(
            style: TextStyle(
              color: provider.isDarkMode()
                  ? MyTheme.primaryDark
                  : MyTheme.primaryDark,
            ),
            controller: viewModel.currentEmailController,
            textAlign: TextAlign.start,
            cursorHeight: 20.h,
            cursorWidth: 1,
            cursorColor: const Color(0xff3660D9),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffDBE4FF),
              hintStyle: const TextStyle(fontSize: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color(0xff3660D9)), // Border color when focused
              ),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(32),
            ],
          ),
        ),
        SizedBox(height: 50.h),
      ],
    );
  }

  Widget buildPasswordTextField(
      String label,
      TextEditingController controller,
      bool obscureText,
      String? errorText,
      VoidCallback onPressed) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: provider.isDarkMode()
                  ? MyTheme.whiteColor
                  : MyTheme.primaryDark,
            ),
          ),
        ),
        SizedBox(
          width: 350.w,
          height: errorText != null ? 70.h : 50.h,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            textAlign: TextAlign.start,
            cursorHeight: 32.h,
            cursorWidth: 1,
            cursorColor: const Color(0xff3660D9),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffDBE4FF),
              hintStyle: const TextStyle(fontSize: 13),
              hintText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color(0xff3660D9)), // Border color when focused
              ),
              errorText: errorText,
              errorMaxLines: 2,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Colors.red.shade700), // Border color on error
              ),
              suffixIcon: IconButton(
                onPressed: onPressed,
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
              ),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(32),
            ],
          ),
        ),
        SizedBox(height: 50.h),
      ],
    );
  }

  void changePassword() {
    if (_formKey.currentState!.validate()) {
      // If all fields are validated successfully, proceed with changing the password
      viewModel.changePassword();
    }
  }
}
