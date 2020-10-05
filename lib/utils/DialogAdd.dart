import 'package:notetify/constant/ScreenSize.dart';
import 'package:notetify/ui/Screens/Link/AddLinkPage.dart';
import 'package:notetify/ui/Screens/Notes/AddData.dart';
import 'package:notetify/ui/Screens/Todos/TodoAddPage.dart';
import 'package:dough/dough.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class BuildAddDialog extends StatelessWidget {
  final FirebaseUser user;

  BuildAddDialog({this.user});

  @override
  Widget build(BuildContext context) {
    return PressableDough(
          child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10)),
        elevation: 1,
        child: Container(
          height: getHeight(context) * 0.24,
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddData(user))).then((v) {
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Notes"))),
              Container(
                  width: double.infinity,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TodoAdd(user))).then((v) {
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Tugas"))),
              Container(
                  width: double.infinity,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddUrlPage(user)))
                            .then((value) {
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Link"))),
            ],
          ),
        ),
      ),
    );
  }
}