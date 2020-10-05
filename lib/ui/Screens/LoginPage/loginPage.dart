import 'package:notetify/constant/ScreenSize.dart';
import 'package:notetify/constant/PrimaryColor.dart';
import 'package:notetify/services/auth_services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LomginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
        body: SafeArea(
            child: Center(
      child: Stack(
        children: <Widget>[

          /// Circle 1
          Circle(),

          /// Circle 2
          Circle2(),

          /// Wave Clip
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: WaveClipperTwo(reverse: true),
              child: Container(
               height: getHeight(context) * 0.14,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                  primaryColor,
                  Color(0xff445ccc),
                ])),
              ),
            ),
          ),

        
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

                /// illustration image
              Container(
                height: getHeight(context) * 0.41,
                width: getHeight(context) * 0.41,
               child: SvgPicture.asset("assets/Mobile-login-bro.svg", fit: BoxFit.cover,),
              ),

              SizedBox(
                height: getHeight(context) * 0.03,
              ),
              
              /// Login text instruction
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Silahkan login terlebih dahulu",
                      style:
                          TextStyle(fontSize: getHeight(context) * 0.027, fontWeight: FontWeight.bold, color: Colors.black),
                    )),
              ),

              SizedBox(
                height: getHeight(context) * 0.01,
              ),
              
              /// Login button with Google
              Container(
                  height: getHeight(context) * 0.07,
                  width: getHeight(context) * 0.29,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          color: Colors.grey.withOpacity(0.3),
                          offset: Offset(2, 4))
                    ],
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(35),
                      onTap: () async {
                        await AuthServices.signInGoogle();
                     
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image.asset("assets/google-icon.png"),
                          Text(
                            "Sign in with Google", style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )),
                  
            ],
          ),
        ],
      ),
    )));
  }
}

class Circle extends StatelessWidget {
  const Circle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 100,
      bottom: getHeight(context) * -0.04,
      top: 0,
      right: getHeight(context) * -0.1,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          height: getHeight(context) * 0.27,
          width: getHeight(context) * 0.27,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                primaryColor,
                Colors.blue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }
}

class Circle2 extends StatelessWidget {
  const Circle2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 100,
      bottom: getHeight(context) * - 0.018,
      top: 0,
      right: getHeight(context) * 0.09,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          height: getHeight(context) * 0.16,
          width: getHeight(context) * 0.16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.greenAccent,
                Colors.blue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }
}

class WaveClipperTwo extends CustomClipper<Path> {
  /// reverse the wave direction in vertical axis
  bool reverse;

  /// flip the wave direction horizontal axis
  bool flip;

  WaveClipperTwo({this.reverse = false, this.flip = false});

  @override
  Path getClip(Size size) {
    var path = Path();
    if (!reverse && !flip) {
      path.lineTo(0.0, size.height - 20);

      var firstControlPoint = Offset(size.width / 4, size.height);
      var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint =
          Offset(size.width - (size.width / 3.25), size.height - 65);
      var secondEndPoint = Offset(size.width, size.height - 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height - 40);
      path.lineTo(size.width, 0.0);
      path.close();
    } else if (!reverse && flip) {
      path.lineTo(0.0, size.height - 40);
      var firstControlPoint = Offset(size.width / 3.25, size.height - 65);
      var firstEndPoint = Offset(size.width / 1.75, size.height - 20);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondCP = Offset(size.width / 1.25, size.height);
      var secondEP = Offset(size.width, size.height - 30);
      path.quadraticBezierTo(
          secondCP.dx, secondCP.dy, secondEP.dx, secondEP.dy);

      path.lineTo(size.width, size.height - 20);
      path.lineTo(size.width, 0.0);
      path.close();
    } else if (reverse && flip) {
      path.lineTo(0.0, 20);
      var firstControlPoint = Offset(size.width / 3.25, 65);
      var firstEndPoint = Offset(size.width / 1.75, 40);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondCP = Offset(size.width / 1.25, 0);
      var secondEP = Offset(size.width, 30);
      path.quadraticBezierTo(
          secondCP.dx, secondCP.dy, secondEP.dx, secondEP.dy);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    } else {
      path.lineTo(0.0, 20);

      var firstControlPoint = Offset(size.width / 4, 0.0);
      var firstEndPoint = Offset(size.width / 2.25, 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint = Offset(size.width - (size.width / 3.25), 65);
      var secondEndPoint = Offset(size.width, 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
