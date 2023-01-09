import 'package:flutter/material.dart';
import 'package:test_live_code/utils/general_sharedpreference.dart';

class InitialPage extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {

  firstActionThisPage()async {
    await Future.delayed(Duration(seconds: 1), () {});
    if (GeneralSharedPreferences.checkContain("is_login")) {
      if (GeneralSharedPreferences.readBool("is_login") == true) {
        Navigator.of(context).pushReplacementNamed("/home");
      } else {
        Navigator.of(context).pushReplacementNamed("/login");
      }
    } else {
      Navigator.of(context).pushReplacementNamed("/login");
    }
  }

  @override
  void initState() {
    firstActionThisPage();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
