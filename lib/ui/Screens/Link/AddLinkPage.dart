import 'package:notetify/constant/ScreenSize.dart';
import 'package:notetify/constant/PrimaryColor.dart';
import 'package:notetify/provider/themeProvider.dart';
import 'package:notetify/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



// ignore: must_be_immutable
class AddUrlPage extends StatelessWidget {
  final FirebaseUser user;
  AddUrlPage(this.user);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String url;
  DateTime dateTime = DateTime.now();

  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      bottomNavigationBar: Container(
        height: getHeight(context) * 0.07,
        color: Colors.black,

        /// Save Button
        child: FlatButton(
            splashColor: Colors.white.withOpacity(0.3),
            color: primaryColor,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                DatabaseServices.addUrl(dateTime, user.email, url);
                Navigator.pop(context);
              } else {
                _autoValidate = true;
              }
            },
            child: Text(
              "SIMPAN",
              style: TextStyle(color: Colors.white),
            )),
      ),

      /// Appbar
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Tambah Link",
          style: TextStyle(
            color: themeChange.darkTheme ? Colors.white : primaryColor,
          ),
        ),
        centerTitle: true,

        /// Back Button
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: themeChange.darkTheme ? Colors.white : primaryColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop()),
      ),

      /// Link Textfield
      body: Form(
        autovalidate: _autoValidate,
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3))),
              child: TextFormField(
                validator: (str) {
                  /// Use regex pattern for validate link
                  Pattern pattern =
                      "^(https?)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]";
                  RegExp regExp = RegExp(pattern);
                  if (!regExp.hasMatch(str)) {
                    return "Masukan link yang valid";
                  } else {
                    return null;
                  }
                },
                onSaved: (str) {
                  url = str;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: "contoh : https://google.com",
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
      
    );
  }
}
