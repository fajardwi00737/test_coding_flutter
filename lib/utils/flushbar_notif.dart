//import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushbarNotif{

  static Flushbar flushbar;

  static FlushbarNotif flushbarTop(
      BuildContext context,
      FlushbarPosition flushbarPosition,
      String txt_message,
      Color color_txt_message,
      Color background_color,
      ){
    Flushbar(
      messageText: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  txt_message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color_txt_message,
                      fontSize: 13,
                      fontFamily: 'PoppinsRegular'
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      margin: EdgeInsets.all(16),
      backgroundColor: background_color,
      borderRadius: 16,
      duration: Duration(seconds: 3),
      flushbarPosition: flushbarPosition,
      flushbarStyle: FlushbarStyle.FLOATING,
    ).show(context);
  }

}