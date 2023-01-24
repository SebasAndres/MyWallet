import 'package:flutter/material.dart';

showAlertDialog (BuildContext context, String msg) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("My Wallet"),
    content: Text(msg),
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}