import 'package:flutter/material.dart';

const String _defaultTitle = 'Oh no!';
const String _defaultContent = 'Something went wrong, try again later.';
const String _defaultButtonText = 'Okay';
Future<dynamic> showDefaultErrorMsg(
  BuildContext context, {
  String title = _defaultTitle,
  String content = _defaultContent,
  String buttonText = _defaultButtonText,
}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            _defaultButtonText,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
      ],
    ),
  );
}
