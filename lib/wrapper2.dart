import 'package:notetify/ui/Screens/LoginPage/loginPage.dart';
import 'package:notetify/ui/Screens/MainPage/HomeMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    /// get firebase user
    FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);

    /// if firebase user null or not login, then go to login page, if has login go to home page
    return firebaseUser == null ? LomginPage() : Home(firebaseUser);
  }
}