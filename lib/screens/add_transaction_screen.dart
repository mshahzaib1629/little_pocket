import 'package:flutter/material.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/helpers/styling.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionType transactionType;

  AddTransactionScreen(this.transactionType);
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  Color _pageThemeColor() {
    Color color = AppTheme.adjustmentColor;
    if (widget.transactionType == TransactionType.Income)
      color = AppTheme.incomeColor;
    else if (widget.transactionType == TransactionType.Expense)
      color = AppTheme.expenseColor;
    else if (widget.transactionType == TransactionType.Adjustment)
      color = AppTheme.adjustmentColor;
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Add ${getEnumStringValue(widget.transactionType.toString())}'),
        backgroundColor: _pageThemeColor(),
      ),
    );
  }
}
