import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showDefaultSnackBar(
    BuildContext context,
    {String text: 'Something went wrong!',
    Color color: Colors.black}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: color,
  ));
}
