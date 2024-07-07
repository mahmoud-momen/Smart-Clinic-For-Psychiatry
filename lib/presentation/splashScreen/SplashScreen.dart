import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_clinic_for_psychiatry/presentation/onBoardScreen/onBoardScreen.dart';


class SplashScreen extends StatelessWidget {
  static const String routeName = 'splash screen';
  const SplashScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff5078F2), Color(0xffEFE9F4)],
        ),
      ),
      child: AnimatedSplashScreen(
        splash: Lottie.asset('assets/images/splash.json'),
        backgroundColor: Colors.transparent,
        nextScreen: OnBoardingScreen(),
        splashIconSize: 350,
        duration: 5000,
        splashTransition: SplashTransition.fadeTransition,
        animationDuration: const Duration(seconds: 1),
      ),
    );
  }

}
