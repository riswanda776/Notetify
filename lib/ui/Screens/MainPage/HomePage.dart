



import 'package:cached_network_image/cached_network_image.dart';
import 'package:notetify/constant/ScreenSize.dart';
import 'package:notetify/ui/Screens/Link/LinkPage.dart';
import 'package:notetify/ui/Screens/Notes/NotePage.dart';
import 'package:notetify/ui/Screens/Todos/TodoPage.dart';
import 'package:notetify/utils/ScrollBehavior.dart';
import 'package:dough/dough.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final FirebaseUser user;
  MainPage(this.user);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Builder(builder: (context) {
          return Column(
            children: <Widget>[
              /// Header User
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Halo",
                            style: TextStyle(
                              fontSize: getHeight(context) * 0.035,
                            ),
                          ),
                          Text(
                            (widget.user.displayName) == null
                                ? widget.user.email
                                : widget.user.displayName,
                            style: TextStyle(
                              fontSize: getHeight(context) * 0.03,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PressableDough(
                    
                                          child: Padding(
                        padding: EdgeInsets.all(10),
                        child: CachedNetworkImage(
                          imageUrl: widget.user.photoUrl,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          imageBuilder: (context, imageProvider) => Container(
                            height: getHeight(context) * 0.063,
                            width: getHeight(context) * 0.063,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              /// Tabbar
              Container(
                height: getHeight(context) * 0.055,
                alignment: Alignment.topLeft,
                child: TabBar(
                  labelPadding: EdgeInsets.symmetric(
                      horizontal: getHeight(context) * 0.03),
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle:
                      TextStyle(fontWeight: FontWeight.normal),
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(
                      text: "Notes",
                    ),
                    Tab(
                      text: "Tugas",
                    ),
                    Tab(
                      text: "Link",
                    ),
                  ],
                ),
              ),

              /// List of page
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                                  child: TabBarView(
                    children: <Widget>[
                      NotesItems(widget.user),
                      TodoPage(widget.user),
                      LinkPage(widget.user),
                    ],
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
