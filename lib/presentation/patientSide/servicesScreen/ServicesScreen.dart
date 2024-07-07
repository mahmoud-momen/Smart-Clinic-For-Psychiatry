import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/presentation/chatBot/screens/ChatBotScreen.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:smart_clinic_for_psychiatry/presentation/patientSide/chatScreen/ChatScreen.dart';
import 'package:smart_clinic_for_psychiatry/presentation/patientSide/servicesScreen/appBar/app_bar.dart';
import 'package:smart_clinic_for_psychiatry/presentation/patientSide/servicesScreen/emoji/emoj.dart';
import 'package:smart_clinic_for_psychiatry/presentation/patientSide/servicesScreen/vitals/vitals.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  static const String routeName = 'home_screen';

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: provider.isDarkMode()
                ? [const Color(0xff121212), const Color(0xff121212)]
                : [const Color(0xff5078F2), const Color(0xffFFFFFF)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WelcomeMessage(),
                Text(
                  AppLocalizations.of(context)!.how_are_you_feeling_today,
                  style: GoogleFonts.poppins(
                    color: provider.isDarkMode()
                        ? MyTheme.whiteColor
                        : MyTheme.whiteColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 15),
                Emoj(),
                SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/find_your_specialist_light.png',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fitWidth,
                      ),
                      Positioned(
                        top: 20,
                        left: 0,
                        right: 120,
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.find_your_specialist,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 40.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              AppLocalizations.of(context)!
                                  .choose_a_doctor_to_help_you_from_our_large_doctors_profiles,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatBotScreen(),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/ai_photo.png',
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fitWidth,
                            ),
                            Positioned(
                              top: 20,
                              left: 20,
                              child: Text(
                                AppLocalizations.of(context)!.talk_with_your_ai,
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 120,
                              left: 20,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .talk_with_your_ai_to_help_you_with_anything_anytime_anywhere,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
