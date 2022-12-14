import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function confirm;
  final String confirmText;
  ConfirmDialog({
    @required this.title,
    @required this.content,
    @required this.confirm,
    this.confirmText = "Confirm",
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: Text(confirmText),
            onPressed: confirm,
          ),
        ],
      );
    } else
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel",style: TextStyle(color:Colors.black87 )),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(confirmText,style: TextStyle(color:Colors.blueAccent )),
            onPressed: confirm,
          ),
        ],
      );
  }
}
