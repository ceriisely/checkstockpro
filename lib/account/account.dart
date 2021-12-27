import 'package:checkstockpro/sharedpref/shared_pref_user.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String username = '';
  String date = '';
  String version = '';
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();

  Future<String?> loadSharedPref() async {
    String _user = await encryptedSharedPreferences
        .getString('username')
        .then((String username) {
      return username;
    });
    String _date = await getStringDateTimeLoginValuesSF() ?? '';
    setState(() {
      username = _user;
      date = _date;
    });
  }

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = 'App version: ' + packageInfo.version + '(' + packageInfo.buildNumber + ')';
  }

  @override
  void initState() {
    super.initState();
    loadSharedPref();
    getVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Container(
              margin: EdgeInsets.all(16),
              child: Column(
                children: [
                  getWidgetOfDataAccount('Username:', username),
                  getWidgetOfDataAccount('Date Login:', date),
                ],
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Color.fromRGBO(64, 101, 246, 1)),
              onPressed: () {
                showDialogLogout(context);
                // Navigator.pop(context);
              },
              child: Text('Logout'),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(version)],
            )
          ],
        ),
      ),
    );
  }

  Widget getWidgetOfDataAccount(String title, String value) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Text(
                  title,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Expanded(
                flex: 2,
                child: Container(
                    margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text(value)))
          ],
        ));
  }

  void showDialogLogout(context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you really want to logout ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'No'),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => {
              clearEncryptedSharedPreferences().then((value) => {
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(pageBuilder: (BuildContext context,
                            Animation animation, Animation secondaryAnimation) {
                          return CheckStockProApp();
                        }, transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) {
                          return new SlideTransition(
                            position: new Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        }),
                        (Route route) => false)
                  }),

              // setUsernameValuesSF(''),
              // setStringDateTimeLoginValuesSF(''),
              // setBoolIsLoginValuesSF(false),
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
