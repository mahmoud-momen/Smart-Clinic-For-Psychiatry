import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/presentation/doctorSide/settingsScreen/about/Content.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';

class AboutScreenDoctor extends StatefulWidget {
  static const String routeName = 'about screen Doctor';
  @override
  _AboutScreenDoctorState createState() => _AboutScreenDoctorState();
}

class _AboutScreenDoctorState extends State<AboutScreenDoctor> {
  late PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var appLocalizations = AppLocalizations.of(context);
    return Scaffold(
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
            top: 88,
            left: 10,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 35.0,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: 88,
            left: 150,
            child: Text(
              AppLocalizations.of(context)!.about,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: MyTheme.whiteColor,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 3; i++)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: _buildPageIndicator(i),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Container(
              height: 600,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildPage(1),
                  _buildPage(2),
                  _buildPage(3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int pageIndex) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == pageIndex ? Colors.blue : Colors.grey,
      ),
    );
  }

  Widget _buildPage(int pageNumber) {
    String text = PageContent.getPageContent(pageNumber);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade300,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
