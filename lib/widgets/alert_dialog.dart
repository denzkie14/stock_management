import 'package:flutter/material.dart';

Future<bool> showAlertDialog(
    BuildContext context, String title, String content) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible:
            false, // Prevents dismissing the dialog by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Return true when confirmed
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      ) ??
      false; // In case the dialog is dismissed without a choice
}
