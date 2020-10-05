import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notetify/constant/ScreenSize.dart';
import 'package:notetify/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:notetify/utils/EmptyContents.dart';

import 'package:url_launcher/url_launcher.dart';

class LinkPage extends StatefulWidget {
  final FirebaseUser user;
  LinkPage(this.user);
  @override
  _LinkPageState createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage>
    with AutomaticKeepAliveClientMixin {
      
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {

      /// Get data from database
    return StreamBuilder<QuerySnapshot>(
        stream: DatabaseServices.getUrlList(widget.user.email),
        builder: (context, snapshot) {

             /// if connection waiting, show progress indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
             /// if data is null, show empty contents
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.documents.length < 1) {
            return Center(
              child: EmptyContent(),
            );

             /// else, show data
          } else {
            return Scrollbar(
              child: ListView(
                padding: EdgeInsets.all(getHeight(context) * 0.01),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Kamu telah menyimpan ${snapshot.data.documents.length} link",
                        style: TextStyle(
                            fontSize: getHeight(context) * 0.023,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  ListUrl(snapshot.data.documents),
                ],
              ),
            );
          }
        });
  }

  @override

  bool get wantKeepAlive => true;
}



class ListUrl extends StatefulWidget {
  final List<DocumentSnapshot> document;

  ListUrl(this.document);

  @override
  _ListUrlState createState() => _ListUrlState();
}

class _ListUrlState extends State<ListUrl> {
  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> list = widget.document;

    return AnimationLimiter(
      child: ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: list.length,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return AnimationConfiguration.staggeredList(
            position: i,
            duration: Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50,
              child: FadeInAnimation(

                /// Slidable, if link slided to right, then show launch icon and copy icon
                child: Slidable(
                  actions: <Widget>[

                    /// Launch Icon
                    Padding(
                      padding: EdgeInsets.only(bottom: getHeight(context) * 0.017),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent, shape: BoxShape.circle),
                        child: IconButton(
                            onPressed: () async {
                              String url = list[i].data['Url'];
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            icon: Icon(
                              Icons.open_in_browser,
                              color: Colors.white,
                            )),
                      ),
                    ),

                    /// Copy Icon
                    Padding(
                      padding: EdgeInsets.only(bottom: getHeight(context) * 0.017),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                        child: IconButton(
                            onPressed: () {
                              String url = list[i].data['Url'];
                              Clipboard.setData(ClipboardData(text: url));
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  duration: Duration(milliseconds: 500),
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    "Link berhasil di copy",
                                    style: TextStyle(color: Colors.white),
                                  )));
                            },
                            icon: Icon(
                              Icons.content_copy,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],

                  /// Slide to left
                  secondaryActions: <Widget>[

                    /// Delete Icon
                    IconSlideAction(
                      color: Colors.transparent,
                      closeOnTap: true,
                      onTap: () {
                        DatabaseServices.deleteUrl(
                            widget.document[i].reference);
                        setState(() {});
                        Scaffold.of(context).showSnackBar(SnackBar(
                            duration: Duration(milliseconds: 500),
                            backgroundColor: Colors.red,
                            content: Text(
                              "Link berhasil di hapus",
                              
                            )));
                      },
                      iconWidget: Padding(
                        padding: EdgeInsets.only(bottom: getHeight(context) * 0.017),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle
                          ),
                                                  child: Icon(Icons.delete,
                              color: Colors.white, size: 35),
                        ),
                      ),
                    ),

                  ],
                  actionExtentRatio: 0.25,
                  actionPane: SlidableDrawerActionPane(),

                  /// Link Content
                  child: Padding(
                      padding:  EdgeInsets.only(
                          top: 0, left: getHeight(context) * 0.01, right: getHeight(context) * 0.01, bottom: getHeight(context) * 0.017),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.7)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(3))),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(

                            /// if link has onLongPress, then copy link
                            onLongPress: () {
                              String url = list[i].data['Url'];
                              Clipboard.setData(ClipboardData(text: url));
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  duration: Duration(milliseconds: 500),
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    "Link berhasil di copy",
                                    style: TextStyle(color: Colors.white),
                                  )));
                            },
                            onTap: () async {
                              String url = list[i].data['Url'];
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },

                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: <Widget>[

                                /// Link
                                Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: getHeight(context) * 0.38,
                                      child: Text(
                                        list[i].data['Url'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                getHeight(context) * 0.022),
                                        textAlign: TextAlign.start,
                                      ),
                                    )),

                                    /// Link Icon
                                Padding(
                                  padding: EdgeInsets.all(
                                      getHeight(context) * 0.016),
                                  child: Icon(Icons.link),
                                ),

                              ],
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}