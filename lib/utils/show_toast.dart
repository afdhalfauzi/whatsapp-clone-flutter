import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showSnackbar(BuildContext context, String message, int durationms) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: durationms),
    ),
  );
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.SNACKBAR,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}