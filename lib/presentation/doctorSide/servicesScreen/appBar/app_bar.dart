import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/data/database/firebase/FireBaseUtils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';

class WelcomeMessage extends StatefulWidget {
  const WelcomeMessage({Key? key}) : super(key: key);

  @override
  State<WelcomeMessage> createState() => _WelcomeMessageState();
}

class _WelcomeMessageState extends State<WelcomeMessage> {
  String? _userName;
  String? _userPicture;

  @override
  void initState() {
    super.initState();
    _getUserName();
    _getUserPicture();
  }

  Future<void> _getUserName() async {
    // Check if a user is signed in
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user signed in');
      return; // Handle the case where no user is signed in
    }

    final String uId = user.uid; // Use actual logic to get ID

    final name = await FirebaseUtils.getUserName(uId);
    setState(() {
      _userName = name;
      print('Retrieved name: $_userName'); // Log the retrieved name
    });
  }

  Future<void> _getUserPicture() async {
    // Check if a user is signed in
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user signed in');
      return; // Handle the case where no user is signed in
    }

    final String uId = user.uid; // Use actual logic to get ID

    final picture = await FirebaseUtils.getUserProfileImage(uId);
    setState(() {
      _userPicture = picture;
      print('Retrieved name: $_userPicture'); // Log the retrieved name
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.good_morning,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: provider.isDarkMode()
                    ? MyTheme.whiteColor
                    : MyTheme.whiteColor, // Set the color to white
              ),
            ),
            Text(
              '${AppLocalizations.of(context)!.doctor}\t${_userName ?? 'User name'}', // Use retrieved name or default
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: provider.isDarkMode() ? MyTheme.whiteColor : MyTheme.whiteColor,
              ),
            ),

            SizedBox(height: 10.h),
          ],
        ),
        Spacer(),
        Container(
          decoration: BoxDecoration(
            color: provider.isDarkMode() ? MyTheme.primaryDark : MyTheme.whiteColor,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.notifications_none_outlined,
                size: 30.sp,
                color: provider.isDarkMode()
                    ? MyTheme.whiteColor
                    : MyTheme.primaryDark,
              ),
              SizedBox(width: 10.w),
              CircleAvatar(
                radius: 20,
                backgroundColor: provider.isDarkMode() ? MyTheme.primaryDark : MyTheme.whiteColor,
                backgroundImage:
                _userPicture != null ? NetworkImage(_userPicture!) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
