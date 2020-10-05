import 'package:notetify/constant/ScreenSize.dart';
import 'package:notetify/icon_file/fun_icon_icons.dart';
import 'package:notetify/provider/themeProvider.dart';
import 'package:notetify/services/database_services.dart';
import 'package:dough/dough.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TodoView extends StatefulWidget {
  final String title;
  final String category;
  final DateTime date;
  final String subtitle;
  final index;

  TodoView(this.title, this.category, this.date, this.subtitle, this.index);

  @override
  _TodoViewState createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final pc = new PanelController();
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    String category = widget.category;
    Color color;
    String image;

    /// check categories to display images according to categories
    switch (category) {
      case "Work":
        {
          color = Colors.red;
          image = "assets/Work-cuate.svg";
        }
        break;
      case "Fun":
        {
          color = Colors.orange;
          image = "assets/game.svg";
        }
        break;
      case "Study":
        {
          color = Colors.purple;
          image = "assets/Studying-cuate.svg";
        }
        break;
      case "Sports":
        {
          color = Colors.blue;
          image = "assets/Soccer-amico.svg";
        }
        break;
      case "Shopping":
        {
          color = Colors.green;
          image = "assets/shop.svg";
        }
        break;
      default:
        {
          color = Colors.blueAccent;
          image = "assets/other.svg";
        }
        break;
    }


    return Scaffold(
        backgroundColor: color,
        body: SafeArea(
          child: Stack(
            children: <Widget>[

              /// Images
              Container(
                margin: EdgeInsets.only(bottom: getHeight(context) * 0.54),
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(image),
              ),

              /// Panel
              SlidingUpPanel(
                controller: pc,
                color: themeChange.darkTheme ? Color(0xff1f1f1f) : Colors.white,
                panel: Panel(
                  title: widget.title,
                  category: widget.category,
                  date: widget.date,
                  subtitle: widget.subtitle,
                  color: color,
                  index: widget.index,
                ),
                minHeight: 380,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),

              /// Back Button
              Align(
                alignment: Alignment.topLeft,
                child: FlatButton(
                    shape: StadiumBorder(),
                    onPressed: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
              ),

            ],
          ),
        ));
  }
}

/// Contens of panel
class Panel extends StatelessWidget {
  final String title;
  final String category;
  final DateTime date;
  final String subtitle;
  final Color color;
  final index;
  Panel(
      {this.title,
      this.category,
      this.date,
      this.subtitle,
      this.color,
      this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: getHeight(context) * 0.03,
          top: getHeight(context) * 0.03,
          right: getHeight(context) * 0.03,
          bottom: getHeight(context) * 0.022),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  /// Title
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: getHeight(context) * 0.034,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                 
                 ///if the task is past than times, show Complete icon, else shoow alert icon
                 Icon(
                       (date.isBefore(DateTime.now())) ? FunIcon.ok_circled :FeatherIcons.alertCircle,
                      )
                ],
              ),

              ///Category
              Container(
                margin: EdgeInsets.symmetric(vertical : getHeight(context) * 0.01),
                height: getHeight(context) * 0.035,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: color, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getHeight(context) * 0.006),
                  child: Text(
                    category,
                    style: TextStyle(color: color, fontWeight: FontWeight.w500),
                  ),
                ),
              ),

              /// Date and description
              Row(
                children: <Widget>[
                  Text(
                    (DateFormat('EEEE, d MMMM', "id_ID").format(date)),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: getHeight(context) * 0.023),
                  ),
                  SizedBox(
                    width: getHeight(context) * 0.01,
                  ),
                  Text(
                    (DateFormat('jm', "id_ID").format(date)),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: getHeight(context) * 0.023),
                  ),
                ],
              ),
              Text(
                subtitle,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),

          /// End the task button
          PressableDough(child: buttonEnd(context, color)),
        ],
      ),
    );
  }

/// widget end task button
  Center buttonEnd(BuildContext context, Color color) {
    return Center(
      child: SizedBox(
        height: getHeight(context) * 0.07,
        width: getHeight(context) * 0.5,
        child: FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: color,    
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      title: Text("Apakah tugas kamu sudah selesai ?"),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Batal")),
                        FlatButton(
                            onPressed: () {
                              DatabaseServices.deleteTodo(index);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text("Ya")),
                      ],
                    );
                  });
            },
            child: Text(
              "Akhiri Tugas",
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
  
}
