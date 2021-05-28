import 'package:flutter/material.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/helpers/styling.dart';
import 'package:little_pocket/models/transaction.dart';

import 'package:intl/intl.dart';
import 'package:little_pocket/screens/transaction_detail_screen.dart';

class HistoryCard extends StatelessWidget {
  final Transaction transaction;
  HistoryCard(this.transaction);

  Widget _transactionArrowCard() {
    Color cardColor = AppTheme.adjustmentColor;
    IconData arrowIcon = Icons.remove;
    if (transaction.transactionType == TransactionType.Income) {
      cardColor = AppTheme.incomeColor;
      arrowIcon = AppTheme.incomeIcon;
    } else if (transaction.transactionType == TransactionType.Expense) {
      cardColor = AppTheme.expenseColor;
      arrowIcon = AppTheme.expenseIcon;
    } else if (transaction.transactionType == TransactionType.Adjustment) {
      cardColor = AppTheme.adjustmentColor;
      arrowIcon = AppTheme.adjustmentIcon;
    }
    return Container(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(
          arrowIcon,
          color: Colors.white,
        ),
      ),
    );
  }

  String _getTimeDifference() {
    DateTime profileViewDateTime = transaction.dateTime;
    int diffInSeconds =
        DateTime.now().difference(profileViewDateTime).inSeconds;
    if (diffInSeconds < 172800) {
      if (diffInSeconds > 86400) {
        double days = diffInSeconds / 86400;
        bool greaterThanOne = days > 1;
        return '${days.toStringAsFixed(0)} day${greaterThanOne ? 's' : ''} ago';
      }
      if (diffInSeconds > 3600) {
        double hours = diffInSeconds / 3600;
        return '${hours.toStringAsFixed(0)} h';
      }
      if (diffInSeconds > 60) {
        double minutes = diffInSeconds / 60;
        bool greaterThanOne = minutes > 1;
        return '${minutes.toStringAsFixed(0)} min${greaterThanOne ? 's' : ''} ago';
      } else {
        return 'just now';
      }
    } else {
      return DateFormat(AppTheme.dateFormat).format(transaction.dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TransactionDetailScreen(transaction)));
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _transactionArrowCard(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction.tag.name,
                      style: AppTheme.cardTitleTextStyle,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(_getTimeDifference()),
                        SizedBox(
                          height: 3,
                        ),
                        Text.rich(
                          TextSpan(
                              text: transaction.balanceChange ==
                                      BalanceChange.Icrement
                                  ? '+'
                                  : '-',
                              style: TextStyle(
                                color: transaction.balanceChange ==
                                        BalanceChange.Icrement
                                    ? AppTheme.amountIcrementColor
                                    : AppTheme.amountDecrementColor,
                                fontSize: 18,
                              ),
                              children: [
                                TextSpan(
                                    text:
                                        ' Rs. ${transaction.amount.toString()}')
                              ]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
