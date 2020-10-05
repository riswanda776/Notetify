import 'package:notetify/constant/ScreenSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
            height: getHeight(context) * 0.35,
            width: getHeight(context) * 0.35,
            child: SvgPicture.asset("assets/Empty-amico.svg")),
            SizedBox(height: getHeight(context) * 0.02),
        Text(
          "Tidak ada data",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: getHeight(context) * 0.025,
          ),
        )
      ],
    );
  }
}