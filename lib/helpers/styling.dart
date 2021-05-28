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

  static String dateTimeFormat = 'EEE, dd MMM yyyy \n hh:mm a';

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

  static TextStyle miniTableHeadingStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static TextStyle formSubmitButtonTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  static TextStyle emptyPageTextStyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  static TextStyle addTagBtnTextStyle = TextStyle(
    color: Colors.black,
  );

  static TextStyle errorTextStyle = TextStyle(
    color: Colors.red,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static InputDecoration inputDecoration(color) => InputDecoration(
        labelStyle: TextStyle(
          color: color,
          fontSize: 20,
        ),
        filled: false,
        errorStyle: errorTextStyle,
        fillColor: color.withOpacity(0.15),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      );
}
