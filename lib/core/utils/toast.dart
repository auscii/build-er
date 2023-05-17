import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Toast {

  static void show(String message, int? position) {
    Fluttertoast.showToast(
        msg: message,
        gravity: position == 1 ? ToastGravity.BOTTOM : ToastGravity.CENTER,
        textColor: Colors.white,
        timeInSecForIosWeb: 1,
        fontSize: 16.0
        // toastLength: Toast.LENGTH_SHORT,
    );
  }

}