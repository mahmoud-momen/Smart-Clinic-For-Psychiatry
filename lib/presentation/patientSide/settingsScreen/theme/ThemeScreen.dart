import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/provider/app_config_provider.dart';

class ThemeScreen extends StatefulWidget {
  static const String routeName = 'language screen';
  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  String selectedTheme = '';

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTheme = prefs.getString('selectedTheme') ?? '';
    });
  }

  Future<void> _saveSelectedLanguage(String themeCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTheme', themeCode);
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
              AppLocalizations.of(context)!.theme,
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
                ThemeButton(
                  theme: AppLocalizations.of(context)!.light,
                  isSelected: selectedTheme == 'Light',
                  onTap: () async {
                    await _saveSelectedLanguage('Light');
                    provider.changeTheme(ThemeMode.light);

                    setState(() {
                      selectedTheme = 'Light';
                    });
                  },
                ),
                ThemeButton(
                  theme: AppLocalizations.of(context)!.dark,
                  isSelected: selectedTheme == 'Dark',
                  onTap: () async {
                    await _saveSelectedLanguage('Dark');
                    provider.changeTheme(ThemeMode.dark);
                    setState(() {
                      selectedTheme = 'Dark';
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

class ThemeButton extends StatelessWidget {
  final String theme;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemeButton({
    Key? key,
    required this.theme,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                theme,
                style: TextStyle(fontSize: 24.sp,
                  color:  provider.isDarkMode()
                      ? MyTheme.whiteColor
                      : MyTheme.primaryDark,
                ),
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
                      color: provider.isDarkMode()
                          ? MyTheme.whiteColor
                          : MyTheme.primaryDark,
                      width: 2,
                    ),
                    color: isSelected ? Colors.green : Colors.white,
                  ),
                  child: isSelected
                      ? Icon(
                    Icons.check,
                    color: provider.isDarkMode()
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

