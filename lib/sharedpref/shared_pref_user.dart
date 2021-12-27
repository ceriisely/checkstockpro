import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static String? userNameValuesSF;
  static String? dbNameValueSF;
}

Future<bool> getBoolIsLoginValuesSF() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return bool

  bool isLogin = prefs.getBool('isLogin') ?? false;
  print('get isLogin: ' + isLogin.toString());
  return isLogin;
}

setBoolIsLoginValuesSF(bool isLogin) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return bool
  await prefs.setBool('isLogin', isLogin);
  print('set isLogin: ' + isLogin.toString());
}

Future<String?> getUsernameValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return bool
  String? username = prefs.getString('username');
  print('get username: ' + username.toString());
  SharedPref.userNameValuesSF = username.toString();
  return username;
}

setUsernameValuesSF(String username) async {
  EncryptedSharedPreferences encryptedSharedPreferences =
  EncryptedSharedPreferences();
  //Return bool
  encryptedSharedPreferences.setString('username', username).then((bool success) {
    if (success) {
      print('set username: ' + username.toString());
      SharedPref.userNameValuesSF = username.toString();
    }
  });
}

Future clearEncryptedSharedPreferences() async {
  EncryptedSharedPreferences encryptedSharedPreferences =
  EncryptedSharedPreferences();
  /// Clears all values, including those you saved using regular Shared Preferences.
  return await encryptedSharedPreferences.clear().then((bool success) {
    if (success) {
      print('clearEncryptedSharedPreferences');
    } else {
      print('clearEncryptedSharedPreferences');
    }
  });
}

setPasswordValuesSF(String password) async {
  EncryptedSharedPreferences encryptedSharedPreferences =
  EncryptedSharedPreferences();
  //Return bool
  encryptedSharedPreferences.setString('password', password).then((bool success) {
    print('setPasswordValuesSF = ' + success.toString());
    if (success) {
      print('set password: ' + password.toString());
    }
  });
}

Future<String?> getStringDateTimeLoginValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return bool
  String? datetime = prefs.getString('datetime');
  print('get datetime: ' + datetime.toString());
  return datetime;
}

setStringDateTimeLoginValuesSF(String datetime) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return bool
  await prefs.setString('datetime', datetime);
  print('set datetime: ' + datetime.toString());
}

setDbNameValueSF(String dbName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return bool
  await prefs.setString('dbName', dbName);
  print('set dbName: ' + dbName.toString());
  SharedPref.dbNameValueSF = dbName.toString();
}