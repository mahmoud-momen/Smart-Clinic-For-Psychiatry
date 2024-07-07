import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset('assets/images/Intro_page.png',
        fit: BoxFit.fill,
        width: double.infinity,
        height: double.infinity,

      ),
    );
  }
}
