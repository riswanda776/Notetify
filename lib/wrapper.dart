
import 'package:notetify/onboard_screen/OnboardScreen.dart';
import 'package:notetify/shared_preferences/onboardPref.dart';
import 'package:notetify/wrapper2.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
bool isFirstTime = false;
_WrapperState(){

  /// get firstTime value
  Onboard.instance.getBoolValue("firstOpen").then((value) {
    setState(() {
      isFirstTime = value;
    });
  });
}

  @override
  Widget build(BuildContext context) {
    
   /// if app firstTime opening / isFirstTime is true, then go to Onboarding Screen, else go to wrapper2
    return isFirstTime ? Wrapper2() : OnboardScreen();
  }
}

  