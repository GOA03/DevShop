import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<dynamic> showDialogHttperror(
  BuildContext context, {
  String title = "Atenção",
  String contet = "Confirma a ação ?",
  String confirm = "OK",
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(contet),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              confirm.toUpperCase(),
              style: TextStyle(
                color: Colors.brown,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
