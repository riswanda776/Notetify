import 'package:shared_preferences/shared_preferences.dart';

class Onboard {
  Onboard._private();

  static final Onboard instance = Onboard._private();

  setBoolValue(String key, bool value) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, value);
  }

  Future<bool> getBoolValue(String key) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key) ?? false;
  }
}
