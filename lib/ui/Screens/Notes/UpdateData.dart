import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notetify/constant/PrimaryColor.dart';
import 'package:notetify/provider/themeProvider.dart';
import 'package:notetify/services/database_services.dart';
import 'package:notetify/utils/ScrollBehavior.dart';
import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateData extends StatefulWidget {
  final List<DocumentSnapshot> document;
  final index;
  final String title;
  final String note;
  UpdateData({
    this.document,
    this.index,
    this.title,
    this.note,
  });
  @override
  _UpdateDataState createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  TextEditingController titleControll = TextEditingController();
  TextEditingController noteControll = TextEditingController();

  void initState() {
    super.initState();
    /// set textfield value
    titleControll = TextEditingController(text: widget.title);
    noteControll = TextEditingController(text: widget.note);
  }


 

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

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
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70),
        /// Appbar
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

                Spacer(),

                /// Delete button
                PressableDough(
                  child: Container(
                    margin:
                        EdgeInsets.only(left: 20, right: 0, top: 20, bottom: 0),
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
                        onTap: () {
                          DatabaseServices.deleteDate(widget.index);
                          Navigator.pop(context);
                        },
                        child: Center(
                            child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        )),
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
                            DatabaseServices.updateData(
                                _dueDate,
                                titleControll.text,
                                noteControll.text,
                                widget.index);
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
                )
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
                          maxLines: null,
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
                              controller: noteControll,
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
