import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notetify/constant/ScreenSize.dart';
import 'package:notetify/provider/themeProvider.dart';
import 'package:notetify/services/database_services.dart';
import 'package:notetify/ui/Screens/Notes/UpdateData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notetify/utils/EmptyContents.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotesItems extends StatefulWidget {
  final FirebaseUser user;

  NotesItems(this.user);

  @override
  _NotesItemsState createState() => _NotesItemsState();
}

class _NotesItemsState extends State<NotesItems>
    with AutomaticKeepAliveClientMixin {

  // ignore: must_call_super
  Widget build(BuildContext context) {
    /// Get data from database
    return StreamBuilder<QuerySnapshot>(
        stream: DatabaseServices.noteList(widget.user.email),
        builder: (context, snapshot) {
          /// if connection is waiting, show progress indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
              /// if data is null, show empty contents
          } else if (snapshot.data.documents.length < 1) {
            return Center(
              child: EmptyContent(),
            );
            /// else, show data
          } else {
            return Scrollbar(child: NotesList(snapshot.data.documents));
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}



class NotesList extends StatelessWidget {
  final List<DocumentSnapshot> document;

  NotesList(this.document);
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return AnimationLimiter(
      child: StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(getHeight(context) * 0.015),
        crossAxisCount: 4,
        shrinkWrap: true,
        itemCount: document.length,
        itemBuilder: (BuildContext context, int i) {
          DateTime date = document[i].data['tanggal'].toDate();
          return AnimationConfiguration.staggeredGrid(
            position: i,
            columnCount: 4,
            duration: Duration(milliseconds: 500),
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: Material(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateData(
                                  document: document,
                                  title: document[i].data['title'],
                                  note: document[i].data['note'],
                                  index: document[i].reference,
                                ))),
                    child: Container(
                        padding: EdgeInsets.all(
                          getHeight(context) * 0.015,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: themeChange.darkTheme
                              ? Color(0xff1f1f1f)
                              : Color(int.parse(
                                      document[i].data['color']))
                                  .withOpacity(0.14),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              document[i].data['title'],
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: getHeight(context) * 0.025,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              (document[i].data['note'] != null)
                                  ? document[i].data['note']
                                  : " ",
                              style: TextStyle(
                                  fontSize: getHeight(context) * 0.018),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 9,
                            ),
                            SizedBox(
                              height: getHeight(context) * 0.02,
                            ),
                            Text(
                              (DateFormat('EEEE, d MMM', "id_ID").format(date)),
                              style: TextStyle(
                                  fontSize: getHeight(context) * 0.018),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 9,
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ),
          );
        },
        staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
    );
  }
}
