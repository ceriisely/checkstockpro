import 'package:checkstockpro/home/home.dart';
import 'package:checkstockpro/services/services.dart';
import 'package:checkstockpro/services/user.dart';
import 'package:checkstockpro/sharedpref/shared_pref_user.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:intl/intl.dart' as intl;
import 'package:package_info_plus/package_info_plus.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  Duration get loginTime => Duration(milliseconds: 2250);
  String version = '';
  EncryptedSharedPreferences encryptedSharedPreferences =
  EncryptedSharedPreferences();

  void login() {
    encryptedSharedPreferences.getString('dbName').then((String dbName) {

    });
  }

  Future<String> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Services.postLogin(data.name, data.password)
        // .delayed(loginTime)
        .then((User? user) {
          if (user != null) {
            setUsernameValuesSF(data.name);
            setPasswordValuesSF(data.password);
            setStringDateTimeLoginValuesSF(
                intl.DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now()));
            setBoolIsLoginValuesSF(true);
            setDbNameValueSF(user.dbName);
            return '';
          } else {
            return 'Login failed';
          }
      // if (!users.containsKey(data.name)) {
      //   return 'User not exists';
      // }
      // if (users[data.name] != data.password) {
      //   return 'Password does not match';
      // }
      // return null;
    });
  }

  FormFieldValidator<String> _userValidator = (value) {
    if (value!.isEmpty) {
      return 'Please input username';
    }
    return null;
  };

  FormFieldValidator<String> _passwordValidator = (value) {
    if (value!.isEmpty) {
      return 'Please input password';
    }
    return null;
  };

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = 'App version: ' + packageInfo.version + '(' + packageInfo.buildNumber + ')';
  }

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      userType: LoginUserType.name,
      userValidator: _userValidator,
      passwordValidator: _passwordValidator,
      title: '',
      messages: LoginMessages(userHint: 'Username'),
      logo: 'images/logo_login.png',
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Home(),
        ));
      },
      hideForgotPasswordButton: true,
      hideSignUpButton: true,
      onRecoverPassword: (name) {},
      onLogin: _authUser,
      onSignup: (LoginData data) {},
      footer: this.version,
    );
  }

}
