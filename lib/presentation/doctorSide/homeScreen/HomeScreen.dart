import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:smart_clinic_for_psychiatry/di/di.dart';
import 'package:smart_clinic_for_psychiatry/presentation/common/components/appTheme/my_theme.dart';
import 'package:smart_clinic_for_psychiatry/presentation/doctorSide/chatScreen/ChatScreen.dart';
import 'package:smart_clinic_for_psychiatry/presentation/doctorSide/homeScreen/HomeScreenViewModel.dart';
import 'package:smart_clinic_for_psychiatry/presentation/doctorSide/servicesScreen/ServicesScreen.dart';
import 'package:smart_clinic_for_psychiatry/presentation/doctorSide/settingsScreen/SettingsScreen.dart';
import 'package:smart_clinic_for_psychiatry/presentation/newsScreen/screens/NewsScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../provider/app_config_provider.dart';


class HomeScreenDoctor extends StatefulWidget {
  static const String routeName = '/home_screen_doctor';

  const HomeScreenDoctor({super.key});

  @override
  _HomeScreenDoctorState createState() {
    return _HomeScreenDoctorState();
  }
}

class _HomeScreenDoctorState extends State<HomeScreenDoctor> {
  var viewModel = getIt<HomeViewModelDoctor>();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return BlocBuilder<HomeViewModelDoctor, HomeScreenState>(
      bloc: viewModel,
      builder: (context, state) {
        int selectedIndex = 0;
        late Widget bodyWidget;

        switch (state.runtimeType) {
          case HomeScreenTabState:
            {
              selectedIndex = 0;
              bodyWidget = const ServicesScreen();
              break;
            }

          case NewsScreenState:
            {
              selectedIndex = 1;
              bodyWidget = const NewsScreen();
              break;
            }

          case ChatScreenState:
            {
              selectedIndex = 2;
              bodyWidget =   ChatScreenDoctor();
              break;
            }

          case SettingsScreenStateDoctor:
            {
              selectedIndex = 3;
              bodyWidget = const SettingsScreenDoctor();
              break;
            }

          default:
            throw Exception("Invalid state: $state");
        }

        return Scaffold(
          backgroundColor: provider.isDarkMode()
              ? MyTheme.primaryDark
              : MyTheme.whiteColor,
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: GNav(
              backgroundColor: MyTheme.primaryLight,
              haptic: true,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              color: MyTheme.whiteColor,
              tabBorderRadius: 20,
              iconSize: 25,
              tabBackgroundColor: MyTheme.backgroundButtonColor,
              activeColor: MyTheme.primaryLight,
              gap: 10,
              onTabChange: (index) {
                viewModel.onTabClick(index);
              },
              tabs: [
                GButton(
                  icon: selectedIndex == 0 ? FontAwesomeIcons.house : FontAwesomeIcons.house,
                  text: AppLocalizations.of(context)!.home,
                ),
                GButton(
                  icon: selectedIndex == 1 ? FontAwesomeIcons.newspaper : FontAwesomeIcons.newspaper,
                  text: AppLocalizations.of(context)!.articles,
                ),
                GButton(
                  icon: selectedIndex == 2 ? FontAwesomeIcons.rocketchat : FontAwesomeIcons.rocketchat,
                  text: AppLocalizations.of(context)!.chat,
                ),
                GButton(
                  icon: selectedIndex == 3 ? Icons.settings : Icons.settings,
                  text: AppLocalizations.of(context)!.settings,
                ),
              ],
            ),
          ),
          body: bodyWidget,
        );
      },
    );
  }
}
