import 'package:flutter/material.dart';

void showToast(BuildContext context, String message, int durationms) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: durationms),
    ),
  );
}