import 'dart:math';
import 'package:notetify/constant/PrimaryColor.dart';
import 'package:notetify/provider/themeProvider.dart';
import 'package:notetify/services/database_services.dart';
import 'package:notetify/utils/ScrollBehavior.dart';
import 'package:dough/dough.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class AddData extends StatelessWidget {
    final FirebaseUser user;
  AddData(this.user);

  /// Color for each note
  List<String> colorsItem = [
    "0xff9AD6F2",
    "0xffFADEB2",
    "0xff2ad1c1",
    "0xffC6D947",
    "0xffF3542A",
    "0xfffe5f55",
    "0xffF5972C",
    "0xff7049F0",
    "0xff7559ff",
    "0xff0AA4F6",
  ];

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    String _note;
    final _random = Random();

    TextEditingController titleControll = TextEditingController();
    DateTime _dueDate = DateTime.now();
    bool _autoValidate = false;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
    
    /// Snackbar if field not filled
    Widget _snackFalse() => SnackBar(
          duration: Duration(milliseconds: 500),
          content: Text(
            "Field belum di isi!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
            textAlign: TextAlign.start,
          ),
          backgroundColor: Colors.redAccent,
        );

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      /// Appbar
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                
                /// Back Button
                PressableDough(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 0),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: themeChange.darkTheme
                          ? Color(0xff3b3b3b)
                          : primaryColor.withOpacity(0.85),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                /// Save Button
                PressableDough(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 0),
                    height: 40,
                    width: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: themeChange.darkTheme
                          ? Color(0xff3b3b3b)
                          : primaryColor.withOpacity(0.85),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          if (_globalKey.currentState.validate() &&
                              titleControll.text != null) {
                            DatabaseServices.addData(
                                user.email,
                                _dueDate,
                                titleControll.text,
                                _note,
                                colorsItem[_random.nextInt(colorsItem.length)]);
                            Navigator.pop(context);
                          } else {
                            final bar = _snackFalse();
                            _scaffoldKey.currentState.showSnackBar(bar);
                          }
                        },
                        child: Center(
                            child: Text(
                          "Simpan",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
     
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Form(
                  key: _globalKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[

                      /// Textfield Title
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: titleControll,
                          onSaved: (value) {},
                          maxLines: null,
                          validator: (value) {
                            if (value.length < 1) {
                              return "Judul kosong";
                            } else {
                              return null;
                            }
                          },
                          style: TextStyle(
                            fontSize: 25,
                          ),
                          decoration: InputDecoration(
                            hintText: "Judul",
                            hintStyle: TextStyle(
                              fontSize: 25,
                            ),
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      /// Textfield contents
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            child: TextFormField(
                              onChanged: (value) {
                                _note = value;
                              },
                              decoration: InputDecoration(
                                hintText: "Isi",
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                            ),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}