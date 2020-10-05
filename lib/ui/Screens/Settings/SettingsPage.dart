import 'package:cached_network_image/cached_network_image.dart';
import 'package:notetify/constant/ScreenSize.dart';

import 'package:notetify/provider/themeProvider.dart';
import 'package:notetify/services/auth_services.dart';
import 'package:dough/dough.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  final FirebaseUser user;

  Settings(this.user);
  @override
  Widget build(BuildContext context) {
   
   final themeChange = Provider.of<DarkThemeProvider>(context);


/// method to send email and send feedback
    sendFeedback() async {
      final Uri params = Uri(
        scheme: 'mailto',
        path: 'riswandahimawan776@gmail.com',
        query:
            'subject=User Feedback - Notetify&body=Tulis kritik dan saranmu disini !', //add subject and body here
      );

      var url = params.toString();
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            /// Profile Picture of user
            Container(
              height: getHeight(context) * 0.2,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  PressableDough(
                    child: CachedNetworkImage(
                      imageUrl: user.photoUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        height: getHeight(context) * 0.09,
                        width: getHeight(context) * 0.09,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: imageProvider)),
                      ),
                    ),
                  ),

                  /// Name of user
                  Text(
                    user.displayName,
                    style: TextStyle(fontSize: getHeight(context) * 0.03),
                  ),

                ],
              ),
            ),

            /// Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color: themeChange.darkTheme ? Colors.white : Colors.grey,
              ),

              /// Dark Mode Button
            ),
            ListTile(
              title: Text("Mode Gelap"),
              leading: Icon(FeatherIcons.moon),
              trailing: Switch(
                  value: themeChange.darkTheme,
                  activeColor: Colors.blueAccent,
                  onChanged: (value) {
                    themeChange.darkTheme = value;
                  }),
            ),

            /// Feedback Button
            Material(
              child: InkWell(
                onTap: sendFeedback,
                child: ListTile(
                  title: Text("Feedback"),
                  leading: Icon(Icons.report),
                ),
              ),
            ),

            /// Sign Out Button
            Material(
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {

                        /// Show confirm dialog for confirmation
                        return AlertDialog(
                          title: Text("Sign Out"),
                          content: Text("Apakah anda yakin untuk Sign Out?"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Batal")),
                            FlatButton(
                                onPressed: () async {
                                  await AuthServices.signOut();
                                  await AuthServices.signOutGoogle();
                                  Navigator.pop(context);
                                },
                                child: Text("Ya")),
                          ],
                        );

                      });
                },
                child: ListTile(
                  title: Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.red),
                  ),
                  leading: Icon(
                    FeatherIcons.logOut,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
