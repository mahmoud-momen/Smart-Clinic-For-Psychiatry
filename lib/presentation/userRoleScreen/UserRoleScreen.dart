import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';

class UserRoleScreen extends StatefulWidget {
  static const String routeName = 'user role';

  const UserRoleScreen({Key? key}) : super(key: key);

  @override
  _UserRoleScreenState createState() => _UserRoleScreenState();
}

class _UserRoleScreenState extends State<UserRoleScreen> {
  int selectedContainerId = -1;

  void navigateToNextScreen() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (selectedContainerId == 0) {
        Navigator.pop(context, AppLocalizations.of(context)!.doctor);
      } else if (selectedContainerId == 1) {
        Navigator.pop(context, AppLocalizations.of(context)!.patient);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      backgroundColor: provider.isDarkMode()
          ? MyTheme.primaryDark
          : MyTheme.selectedIconBlueColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 150.h),
              Text(
                AppLocalizations.of(context)!.you_are_a,
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: MyTheme.primaryLight,
                ),
              ),
              SizedBox(height: 50.h),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedContainerId != 0) {
                      selectedContainerId = 0;
                      navigateToNextScreen();
                    }
                  });
                },
                child: Container(
                  width: 225.0.w,
                  height: 225.0.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MyTheme.primaryLight,
                      width: 4.h,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                    color: selectedContainerId == 0
                        ? MyTheme.primaryLight
                        : Colors.transparent,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 80.h,
                        left: 50.w,
                        child: Image.asset(
                          'assets/images/doctor_framed.png',
                          width: 110.w,
                          color: selectedContainerId == 0
                              ? MyTheme.selectedIconBlueColor
                              : null,
                        ),
                      ),
                      Positioned(
                        top: 30.h,
                        left: 60.w,
                        child: Text(
                          AppLocalizations.of(context)!.doctor,
                          style: TextStyle(
                            color: selectedContainerId == 0
                                ? MyTheme.selectedIconBlueColor
                                : MyTheme.primaryLight,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedContainerId != 1) {
                      selectedContainerId = 1;
                      navigateToNextScreen();
                    }
                  });
                },
                child: Container(
                  width: 225.0.w,
                  height: 225.0.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MyTheme.primaryLight,
                      width: 4.h,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                    color: selectedContainerId == 1
                        ? MyTheme.primaryLight
                        : Colors.transparent,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 80.h,
                        left: 50.w,
                        child: Image.asset(
                          'assets/images/patient_framed.png',
                          width: 110.w,
                          color: selectedContainerId == 1
                              ? MyTheme.selectedIconBlueColor
                              : null,
                        ),
                      ),
                      Positioned(
                        top: 30.h,
                        left: 55.w,
                        child: Text(
                          AppLocalizations.of(context)!.patient,
                          style: TextStyle(
                            color: selectedContainerId == 1
                                ? MyTheme.selectedIconBlueColor
                                : MyTheme.primaryLight,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 150.h),
            ],
          ),
        ),
      ),
    );
  }
}
