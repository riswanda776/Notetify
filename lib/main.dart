import 'package:notetify/provider/themeProvider.dart';
import 'package:notetify/services/auth_services.dart';
import 'package:notetify/styles/styles.dart';
import 'package:notetify/ui/Screens/SplashScreen/Splash.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null).then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
  
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) {
          return themeChangeProvider;
        },
        child: StreamProvider.value(
          value: AuthServices.firebaseUserStream,
          child: Consumer<DarkThemeProvider>(
            builder: (context, value, _) => MaterialApp(
              title: "Notetify",
              theme: Styles.themeData(themeChangeProvider.darkTheme, context),
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
            ),
          ),
        ));
  }
}
