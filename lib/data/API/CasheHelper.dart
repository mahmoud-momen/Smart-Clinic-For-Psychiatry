import 'package:shared_preferences/shared_preferences.dart';

class CasheHelper{
  static late SharedPreferences pref;
  static Future<void> init() async {
    pref = await SharedPreferences.getInstance();
  }

  static saveData(String key, dynamic value) async {
    if (value is String) {
      return await pref.setString(key, value);
    } else if (value is int) {
      return await pref.setInt(key, value);
    } else if (value is bool) {
      return await pref.setBool(key, value);
    } else {
      return await pref.setDouble(key, value);
    }
  }
  static getData(String key){
    return pref.get(key);
  }
}
