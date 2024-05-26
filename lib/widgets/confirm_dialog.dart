import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(
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
                  Navigator.of(context)
                      .pop(false); // Return false when cancelled
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Return true when confirmed
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      ) ??
      false; // In case the dialog is dismissed without a choice
}
