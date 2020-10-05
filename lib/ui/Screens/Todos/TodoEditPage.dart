import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notetify/constant/ScreenSize.dart';
import 'package:notetify/constant/PrimaryColor.dart';
import 'package:notetify/date_timeline/date_picker_widget.dart';
import 'package:notetify/date_timeline/extra/dimen.dart';
import 'package:notetify/provider/themeProvider.dart';
import 'package:notetify/services/database_services.dart';
import 'package:notetify/utils/ScrollBehavior.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodoEdit extends StatefulWidget {
  final String title;
  final String details;
  final String category;
  final DateTime date;
  final int notifID;

  final index;
  TodoEdit(this.title, this.details, this.date, this.index, this.category,
      this.notifID);
  @override
  _TodoEditState createState() => _TodoEditState();
}

class _TodoEditState extends State<TodoEdit> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  /// List of category
  List<String> reportList = [
    "Work",
    "Shopping",
    "Sports",
    "Study",
    "Fun",
    "Other"
  ];

  String selectedChoice = "";
  String title;
  String details;
  String selectedTimer = "Pilih Waktu";
  int notifID;
  bool reminder = true;

  DateTime selectedValue = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Create object local notifications
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initState() {
    super.initState();

    /// Initialize value of task for add to each field
    titleController = TextEditingController(text: widget.title);
    detailsController = TextEditingController(text: widget.details);
    selectedValue = DateTime(widget.date.year, widget.date.month,
        widget.date.day, widget.date.hour, widget.date.minute);
    selectedTimer = DateFormat('jm', "id_ID").format(widget.date);
    timeOfDay = TimeOfDay(hour: widget.date.hour, minute: widget.date.minute);
    selectedChoice = widget.category;
    notifID = widget.notifID;

    /// Initialize Notification
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  /// Contents of notification
  showNotification(
      int id, String titleTask, String deskripsi, DateTime time) async {
    var scheduledNotificationDateTime = time;
    var android = new AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);

    await flutterLocalNotificationsPlugin.schedule(
        id,
        "Halo, sekarang waktunya $titleTask",
        deskripsi,
        scheduledNotificationDateTime,
        platform);
  }

  Future onSelectNotification(String payload) {}

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Category selector
  _buildChoiceList(BuildContext context) {
    List<Widget> choices = List();
    final themeChange = Provider.of<DarkThemeProvider>(context);

    reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(3.0),
        child: ChoiceChip(
          backgroundColor: Colors.grey.withOpacity(0.2),
          selectedColor: primaryColor,
          label: Text(
            item,
            style: TextStyle(
                color: selectedChoice == item
                    ? themeChange.darkTheme ? Colors.white : Colors.white
                    : null),
          ),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
              print(selectedChoice);
            });
          },
        ),
      ));
    });
    return choices;
  }

  /// Get Timer
  pickerTimer() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: widget.date.hour, minute: widget.date.minute),
    );

    if (selectedTime != null) {
      setState(() {
        timeOfDay = selectedTime;
        selectedValue = DateTime(selectedValue.year, selectedValue.month,
            selectedValue.day, timeOfDay.hour, timeOfDay.minute);
        selectedTimer = DateFormat("jm", "id_ID").format(selectedValue);
        print(selectedValue);
        print(timeOfDay);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    /// ID For Notification
    int idNotification =
        (DateTime.now().microsecondsSinceEpoch / 1000000).truncate().toInt();
    print(idNotification);

    bool _autoValidate = false;
    print(notifID);
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        height: 50,

        /// Save Button
        child: Builder(
          builder: (context) => FlatButton(
              onPressed: () {
                if (selectedChoice == "") {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(milliseconds: 500),
                      backgroundColor: Colors.orangeAccent,
                      content: Text("Kategori belum dpilih")));
                } else if (selectedValue.isBefore(DateTime.now())) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(milliseconds: 500),
                      backgroundColor: Colors.orangeAccent,
                      content: Text("Waktu sudah terlewati")));
                } else {
                  if (_formKey.currentState.validate()) {
                    {
                      _formKey.currentState.save();
                      DatabaseServices.updateTodoList(selectedValue,
                          selectedChoice, title, details, widget.index);
                      if (reminder) {
                        cancelNotification(notifID);
                        showNotification(
                            idNotification, title, details, selectedValue);
                      }
                       cancelNotification(notifID);
                      Navigator.pop(context);
                    }
                  }
                }
              },
              child: Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),

      /// Appbar
      appBar: AppBar(
        centerTitle: true,

        ///Back button
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: themeChange.darkTheme ? Colors.white : primaryColor,
          ),
        ),
        elevation: 0,
        title: Text(
          "Edit Tugas",
          style: TextStyle(
              color: themeChange.darkTheme ? Colors.white : primaryColor,
              fontSize: 18),
        ),
      ),

      body: SafeArea(
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            children: <Widget>[
              Container(
                height: 100,
                child: Material(
                  /// Date picker
                  child: DatePicker(
                    selectedValue.isAfter(DateTime.now())
                        ? DateTime.now()
                        : selectedValue,
                    dayTextStyle: TextStyle(
                      color:
                          themeChange.darkTheme ? Colors.white : Colors.black,
                      fontSize: Dimen.dayTextSize,
                      fontWeight: FontWeight.w500,
                    ),
                    dateTextStyle: TextStyle(
                      color:
                          themeChange.darkTheme ? Colors.white : Colors.black,
                      fontSize: Dimen.dateTextSize,
                      fontWeight: FontWeight.w500,
                    ),
                    monthTextStyle: TextStyle(
                      color:
                          themeChange.darkTheme ? Colors.white : Colors.black,
                      fontSize: Dimen.monthTextSize,
                      fontWeight: FontWeight.w500,
                    ),
                    initialSelectedDate: selectedValue,
                    selectionColor: primaryColor,
                    selectedTextColor: Colors.white,
                    locale: "id_ID",
                    onDateChange: (date) {
                      // New date selected
                      setState(() {
                        selectedValue = DateTime(date.year, date.month,
                            date.day, timeOfDay.hour, timeOfDay.minute);
                        print(selectedValue);
                      });
                    },
                  ),
                ),
              ),

              /// Category selector
              Container(
                height: 50,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: _buildChoiceList(context),
                ),
              ),

              /// Picked for time
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => pickerTimer(),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          selectedTimer,
                          style:
                              TextStyle(fontSize: getHeight(context) * 0.025),
                        ),
                        Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),
              ),

              /// Textfields and switch
              Form(
                autovalidate: _autoValidate,
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    ///Title textfield
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: TextFormField(
                          controller: titleController,
                          autovalidate: _autoValidate,
                          validator: (value) {
                            if (value.length < 1)
                              return "Title harus di isi";
                            else
                              return null;
                          },
                          onSaved: (value) {
                            title = value;
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintText: "Nama Tugas",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: themeChange.darkTheme
                                          ? Colors.white70
                                          : Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor))),
                        ),
                      ),
                    ),

                    /// Description textfield
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: TextFormField(
                          controller: detailsController,
                          onSaved: (value) {
                            details = value;
                          },
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              hintText: "Deskripsi",
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: themeChange.darkTheme
                                          ? Colors.white70
                                          : Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor))),
                        ),
                      ),
                    ),

                      // Reminder switch
                    SwitchListTile(
                      value: reminder,
                      activeColor: primaryColor,
                      onChanged: (v) {
                        setState(() {
                          reminder = v;
                          print(v);
                        });
                      },
                      title: Text("Ingatkan saya"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
