import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/di/di.dart';
import 'package:smart_clinic_for_psychiatry/presentation/authentication/loginScreen/LoginScreen.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/dialogUtils/dialogUtils.dart';
import 'package:smart_clinic_for_psychiatry/presentation/patientSide/settingsScreen/SettingsScreenViewModel.dart';
import 'package:smart_clinic_for_psychiatry/presentation/patientSide/settingsScreen/about/AboutScreen.dart';
import 'package:smart_clinic_for_psychiatry/presentation/patientSide/settingsScreen/editProfile/EditProfileScreen.dart';
import 'package:smart_clinic_for_psychiatry/presentation/patientSide/settingsScreen/language/LanguageScreen.dart';
import 'package:smart_clinic_for_psychiatry/presentation/patientSide//settingsScreen/theme/ThemeScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = 'settings screen';

  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var viewModel = getIt<SettingsViewModel>();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return BlocListener<SettingsViewModel, SettingsViewState>(
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
                  posActionName: AppLocalizations.of(context)!.ok);
            }
          case LoadingState():
            {
              DialogUtils.showLoading(
                  context, AppLocalizations.of(context)!.loading);
            }
          case LogoutSuccessState():
            {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // Delayed navigation function
                  void delayedNavigation() {
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName);
                    });
                  }

                  // Call the delayed navigation function
                  delayedNavigation();

                  return AlertDialog(
                    content: Text(
                      AppLocalizations.of(context)!.logged_out_successfully,
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                },
              );
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
            Positioned(
              top: 80,
              left: 112,
              child: Text(
                AppLocalizations.of(context)!.settings,
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.whiteColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildSettingsButton(
                    title: AppLocalizations.of(context)!.edit_profile,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 35,
                  ),
                  _buildSettingsButton(
                    title: AppLocalizations.of(context)!.language,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LanguageScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 35,
                  ),
                  _buildSettingsButton(
                    title: AppLocalizations.of(context)!.theme,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThemeScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 35,
                  ),
                  _buildSettingsButton(
                    title: AppLocalizations.of(context)!.about,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () async {
                      // Show logout confirmation dialog
                      bool logoutConfirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!
                                .logout_confirmation),
                            content: Text(AppLocalizations.of(context)!
                                .are_you_sure_you_want_to_logout),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      false); // Return false if cancel is pressed
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.cancel),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      true); // Return true if yes is pressed
                                },
                                child: Text(AppLocalizations.of(context)!.yes),
                              ),
                            ],
                          );
                        },
                      );

                      // Check if logout is confirmed
                      if (logoutConfirmed == true) {
                        logout();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 8,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.log_out,
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.white,
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

  void logout() {
    viewModel.logout();
  }

  Widget _buildSettingsButton(

      {required String title, required VoidCallback onTap,   }) {
    var provider = Provider.of<AppConfigProvider>(context);
    return ListTile(

      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24.sp,
              color: provider.isDarkMode()
                  ? MyTheme.whiteColor
                  : MyTheme.primaryDark,
            ),
          ),
          const Spacer(),
          const Icon(Icons.navigate_next),
        ],
      ),
      onTap: onTap,
    );
  }
}
