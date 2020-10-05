import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notetify/constant/ScreenSize.dart';
import 'package:notetify/constant/PrimaryColor.dart';
import 'package:notetify/icon_file/fun_icon_icons.dart';
import 'package:notetify/provider/themeProvider.dart';
import 'package:notetify/services/database_services.dart';
import 'package:notetify/ui/Screens/Todos/TodoEditPage.dart';
import 'package:notetify/ui/Screens/Todos/TodoViewPage.dart';
import 'package:dough/dough.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:notetify/utils/EmptyContents.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodoPage extends StatefulWidget {
  final FirebaseUser user;
  TodoPage(this.user);
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {

    /// Get data from database
    return StreamBuilder(
        stream: DatabaseServices.getTodoList(widget.user.email),
        builder: (context, snapshot) {
          /// if connection waiting, show progress indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());

            /// if data is null, show empty contents
          } else if (snapshot.data.documents.length < 1) {
            return Center(
              child: EmptyContent(),
            );

            /// else, show data
          } else {
            return ItemList(snapshot.data.documents);
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}


class ItemList extends StatelessWidget {
    final List<DocumentSnapshot> document;
     ItemList(this.document);

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> list = document;
    final themeChange = Provider.of<DarkThemeProvider>(context);

/// icon category
    Widget iconsType(
        {List<Color> gradientColors, Color shadowColor, IconData icon}) {
      return Container(
        height: getHeight(context) * 0.065,
        width: getHeight(context) * 0.065,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 7,
                offset: Offset(1, 3),
              )
            ]),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      );
    }

    return AnimationLimiter(
      child: PressableDough(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 2),
            itemCount: list.length,
            itemBuilder: (context, i) {
              IconData icons;
              Widget ikon;
              String icon = list[i].data['Category'];
              
              /// validate each icon
              switch (icon) {
                case "Work":
                  {
                    ikon = iconsType(
                        icon: FunIcon.briefcase,
                        gradientColors: [Colors.red, Colors.pinkAccent],
                        shadowColor: Colors.red);
                  }
                  break;
                case "Shopping":
                  {
                    ikon = iconsType(
                        icon: FunIcon.basket,
                        gradientColors: [Colors.greenAccent, Colors.green],
                        shadowColor: Colors.green);
                  }
                  break;
                case "Sports":
                  {
                    ikon = iconsType(
                        icon: FunIcon.soccer_ball,
                        gradientColors: [Colors.blueAccent, Colors.blue],
                        shadowColor: Colors.blueAccent);
                  }
                  break;
                case "Study":
                  {
                    ikon = iconsType(
                        icon: Icons.school,
                        gradientColors: [Colors.purple, Colors.purpleAccent],
                        shadowColor: Colors.purple);
                  }
                  break;
                case "Fun":
                  {
                    ikon = iconsType(
                        icon: FunIcon.gamepad,
                        gradientColors: [
                          Colors.orangeAccent,
                          Colors.orangeAccent
                        ],
                        shadowColor: Colors.orange);
                  }
                  break;
                case "Other":
                  {
                    ikon = iconsType(
                        icon: FunIcon.menu,
                        gradientColors: [primaryColor, Colors.blueGrey],
                        shadowColor: Colors.blueGrey);
                  }
                  break;
                default:
                  {
                    icons = Icons.insert_chart;
                  }
                  break;
              }

              DateTime date = list[i].data['Date'].toDate();
              var now = DateTime.now();
              
              /// Listview of data
              return AnimationConfiguration.staggeredList(
                position: i,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 100,
                  child: FadeInAnimation(
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: themeChange.darkTheme
                                ? Color(0xff292929)
                                : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                offset: Offset(0, 2),
                                blurRadius: 5,
                              )
                            ]),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TodoView(
                                            list[i].data["Title"],
                                            list[i].data["Category"],
                                            date,
                                            list[i].data["Details"],
                                            list[i].reference,
                                          )));
                            },
                            child: ListTile(

                              /// Title
                              title: Padding(
                                padding: EdgeInsets.only(
                                    top: getHeight(context) * 0.012),
                                child: Text(
                                  list[i].data['Title'],
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),

                              /// Icon 
                              leading: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 1,
                                ),
                                child: ikon,
                              ),

                              /// if details is null, then show this widget
                              subtitle: list[i].data['Details'] == ""
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[

                                         /// if the task date is the same as today, it shows "Today", otherwise the date is displayed
                                        Text(
                                          date.day == now.day
                                              ? "Hari Ini"
                                              : (DateFormat(
                                                      'EEEE, d MMM', "id_ID")
                                                  .format(date)),
                                          style: TextStyle(
                                              fontSize:
                                                  getHeight(context) * 0.018),
                                        ),
                                        Text(
                                          (DateFormat('jm', "id_ID")
                                              .format(date)),
                                          style: TextStyle(
                                              fontSize:
                                                  getHeight(context) * 0.018),
                                        ),
                                      ],
                                    )

                                    /// otherwise show this widget
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[

                                            /// if the task date is the same as today, it shows "Today", otherwise the date is displayed
                                            Text(
                                              date.day == now.day
                                                  ? "Hari Ini"
                                                  : (DateFormat('EEEE, d MMM',
                                                          "id_ID")
                                                      .format(date)),
                                              style: TextStyle(
                                                  fontSize: getHeight(context) *
                                                      0.018),
                                            ),
                                            Text(
                                              (DateFormat('jm', "id_ID")
                                                  .format(date)),
                                              style: TextStyle(
                                                  fontSize: getHeight(context) *
                                                      0.018),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          list[i].data['Details'],
                                          style: TextStyle(
                                              fontSize:
                                                  getHeight(context) * 0.016),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),

                                    /// if the task is past its time, then show the complete icons, otherwise show the edit icon
                              trailing: date.isBefore(DateTime.now())
                                  ? Padding(
                                      padding: EdgeInsets.all(
                                          getHeight(context) * 0.01),
                                      child: Icon(
                                        FunIcon.ok_circled,
                                        color: Colors.green,
                                        size: getHeight(context) * 0.045,
                                      ),
                                    )
                                  : IconButton(
                                      tooltip: "Edit",
                                      icon: Icon(
                                        Icons.edit,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TodoEdit(
                                                      list[i].data['Title'],
                                                      list[i].data['Details'],
                                                      date,
                                                      list[i].reference,
                                                      list[i].data["Category"],
                                                      list[i].data['NotificationID'],
                                                    )));
                                      }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
