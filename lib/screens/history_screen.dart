import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/helpers/styling.dart';
import 'package:little_pocket/models/transaction.dart';
import 'package:little_pocket/providers/transaction_provider.dart';
import 'package:little_pocket/screens/add_transaction_screen.dart';
import 'package:little_pocket/screens/app_drawer.dart';
import 'package:little_pocket/widgets/history_card.dart';
import 'package:little_pocket/widgets/history_screen_floating_button.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HawkFabMenuItem> _floatButtonMenuList(context) => [
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
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Little Pocket'),
      ),
      drawer: AppDrawer(),
      body: HawkFabMenu(
        items: _floatButtonMenuList(context),
        body: Consumer<TransactionProvider>(
          builder: (context, transactionSnap, _) {
            List<Transaction> _transactions = transactionSnap.myTransactions;
            return ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) => Column(
                      children: [
                        HistoryCard(_transactions[index]),
                        // if (index != _transactions.length - 1)
                        Divider(
                          height: 0,
                          color: Colors.black26,
                        ),
                      ],
                    ));
          },
        ),
      ),
    );
  }
}
