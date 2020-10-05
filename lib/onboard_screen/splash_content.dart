import 'package:notetify/constant/PrimaryColor.dart';
import 'package:notetify/constant/ScreenSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashContent extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;

  SplashContent({this.title, this.subTitle, this.image});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Text(
          title,
          style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: getHeight(context) * 0.036),
        ),
        Text(
          subTitle,
          style: TextStyle(color: Colors.grey),
        ),
        Spacer(),
        SvgPicture.asset(
          image,
          fit: BoxFit.cover,
          height: getHeight(context) * 0.35,
          width: getHeight(context) * 0.35,
        )
      ],
    );
  }
}
