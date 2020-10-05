import 'package:notetify/constant/ScreenSize.dart';
import 'package:notetify/constant/PrimaryColor.dart';
import 'package:notetify/provider/themeProvider.dart';
import 'package:notetify/ui/Screens/MainPage/HomePage.dart';
import 'package:notetify/ui/Screens/Settings/SettingsPage.dart';
import 'package:notetify/utils/DialogAdd.dart';
import 'package:dough/dough.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final FirebaseUser user;
  Home(this.user);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    /// Widget Navbar Items
    Widget buildNavbarItems(
      int index,
      IconData icons,
    ) {
      return IconButton(
        onPressed: () {
          setState(() {
            selectedIndex = index;
          });
        },
        icon: Icon(
          icons,
          size: getHeight(context) * 0.038,
          color: index == selectedIndex
              ? themeChange.darkTheme
                  ? Colors.white
                  : Colors.black.withOpacity(0.8)
              : themeChange.darkTheme
                  ? Colors.white.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.65),
        ),
      );
    }

    /// List of page
    List<Widget> _pages = [
      MainPage(widget.user),
      Settings(widget.user),
    ];

    return Scaffold(
      /// Bottom Navigation Bar
        body: IndexedStack(
          index: selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              blurRadius: 6,
              offset: Offset(0, 3),
              spreadRadius: 0,
            )
          ]),
          height: getHeight(context) * 0.075,
          child: Material(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildNavbarItems(0, FeatherIcons.home),
                PressableDough(
                  child: Container(
                    height: getHeight(context) * 0.043,
                    width: getHeight(context) * 0.11,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            Colors.blue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          showGeneralDialog(
                            context: context,
                            barrierColor: Colors.black38,
                            transitionBuilder: (context, a1, a2, widget) {
                              final curvedValue =
                                  Curves.easeInOutBack.transform(a1.value) -
                                      1.0;
                              FirebaseUser user =
                                  Provider.of<FirebaseUser>(context);
                              return Transform(
                                transform: Matrix4.translationValues(
                                    1, curvedValue * 200, 0),
                                child: Opacity(
                                  opacity: a1.value,
                                  child: BuildAddDialog(
                                    user: user,
                                  ),
                                ),
                              );
                            },
                            transitionDuration: Duration(milliseconds: 300),
                            barrierDismissible: true,
                            // ignore: missing_return
                            pageBuilder: (context, a1, a2) {},
                            barrierLabel: '',
                          );
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                buildNavbarItems(1, FeatherIcons.settings),
              ],
            ),
          ),
        ));
  }
}
