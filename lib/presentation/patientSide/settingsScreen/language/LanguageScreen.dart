import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';

class LanguageScreen extends StatefulWidget {
  static const String routeName = 'language screen';
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = '';

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('selectedLanguage') ?? '';
    });
  }

  Future<void> _saveSelectedLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageCode);
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
            left: 120,
            child: Text(
              AppLocalizations.of(context)!.language,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: MyTheme.whiteColor,
              ),
            ),
          ),
          Positioned(
            top: 240,
            left: 0,
            right: 0,
            child: Column(
              children: [
                LanguageButton(
                  language: AppLocalizations.of(context)!.arabic,
                  isSelected: selectedLanguage == 'ar',
                  onTap: () async {
                    await _saveSelectedLanguage('ar');
                    provider.changeLanguage('ar');

                    setState(() {
                      selectedLanguage = 'ar';
                    });
                  },
                ),
                LanguageButton(
                  language: AppLocalizations.of(context)!.english,
                  isSelected: selectedLanguage == 'en',
                  onTap: () async {
                    await _saveSelectedLanguage('en');
                    provider.changeLanguage('en');

                    setState(() {
                      selectedLanguage = 'en';
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageButton({
    Key? key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              Text(
                language,
                style: TextStyle(fontSize: 24.sp,
                    color: provider.isDarkMode()
                        ? MyTheme.whiteColor
                        : MyTheme.primaryDark, ),
              ),
              Spacer(),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:  provider.isDarkMode()
                          ? MyTheme.whiteColor
                          : MyTheme.primaryDark,
                      width: 2,
                    ),
                    color: isSelected ? Colors.green : Colors.white,
                  ),
                  child: isSelected
                      ? Icon(
                    Icons.check,
                    color:  provider.isDarkMode()
                        ? MyTheme.whiteColor
                        : MyTheme.primaryDark,
                    size: 18,
                  )
                      : null,
                ),
              ),
            ],
          ),
          onTap: onTap,
        ),
        Divider(
          indent: 20,
          endIndent: 35,
        ),
      ],
    );
  }
}


