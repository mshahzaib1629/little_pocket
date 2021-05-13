import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = Colors.blue;
  static ThemeData themeData = ThemeData(
    primarySwatch: primaryColor,
  );

  static TextStyle cardTitleTextStyle = TextStyle(
    fontSize: 16,
  );
  static String dateFormat = 'EEE, dd MMM yyyy';

  static String dateTimeFormat = 'EEE, dd MMM yyyy AT hh:mm a';

  static Color incomeColor = primaryColor;
  static IconData incomeIcon = Icons.arrow_downward;
  static Color expenseColor = Colors.red;
  static IconData expenseIcon = Icons.arrow_upward;
  static Color adjustmentColor = Colors.yellow.shade800;
  static IconData adjustmentIcon = Icons.remove;

  static Color amountIcrementColor = Colors.green;
  static Color amountDecrementColor = Colors.red;

  static TextStyle tagTextStyle = TextStyle(
    color: Colors.white,
  );

  static TextStyle addTagBtnTextStyle = TextStyle(
    color: Colors.black,
  );
}
