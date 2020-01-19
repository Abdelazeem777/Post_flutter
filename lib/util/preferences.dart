import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static String _ID = "PREF_ID";
  static String _userName = "USER_NAME";

  static Future<String> getId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ID);
  }

  static Observable<void> setId(String id) {
    return Observable.fromFuture(SharedPreferences.getInstance()).map((prefs) {
      print("the id is " + id);
      return prefs.setString(_ID, id);
    });
  }

  static Future<String> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userName);
  }

  static setUserName(String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_userName, userName);
  }

  static Observable<void> clear() {
    return Observable.fromFuture(SharedPreferences.getInstance()).map((prefs) {
      return prefs.clear();
    });
  }
}
