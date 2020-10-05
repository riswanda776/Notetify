import 'dart:async';

import 'package:notetify/constant/ScreenSize.dart';
import 'package:notetify/wrapper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  initState(){
    super.initState();
    startSplash();
  }

  startSplash() {
    var duration = Duration(milliseconds: 500);
    return Timer(
        duration,
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Wrapper())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SizedBox(
          height: getHeight(context) * 0.1,
          width: getHeight(context) * 0.1,
          child: Image.asset("assets/icon_launcher/icon_launcher.png")),
      ),
    );
  }
}
