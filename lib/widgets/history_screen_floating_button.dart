import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/helpers/styling.dart';
import 'package:little_pocket/screens/add_transaction_screen.dart';

class HistoryScreenFloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HawkFabMenu(
      body: SizedBox(),
      icon: AnimatedIcons.menu_arrow,
      // fabColor: Colors.yellow,
      // iconColor: Colors.green,
      items: [
        HawkFabMenuItem(
          label: 'Income',
          ontap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(
                TransactionType.Income,
              ),
            ),
          ),
          icon: Icon(AppTheme.incomeIcon),
          color: AppTheme.incomeColor,
          labelColor: Colors.black,
        ),
        HawkFabMenuItem(
          label: 'Expense',
          ontap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(
                TransactionType.Expense,
              ),
            ),
          ),
          icon: Icon(AppTheme.expenseIcon),
          color: AppTheme.expenseColor,
          labelColor: Colors.black,
        ),
        HawkFabMenuItem(
          label: 'Adjustment',
          ontap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(
                TransactionType.Adjustment,
              ),
            ),
          ),
          icon: Icon(AppTheme.adjustmentIcon),
          color: AppTheme.adjustmentColor,
          labelColor: Colors.black,
        ),
      ],
    );
  }
}
