import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/helpers/styling.dart';
import 'package:little_pocket/models/transaction.dart';

class TransactionDetailScreen extends StatefulWidget {
  Transaction transaction;
  TransactionDetailScreen(this.transaction);

  @override
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  TextEditingController _descriptionTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionTextController.text =
        widget.transaction.description ?? 'No description.';
  }

  Color _pageThemeColor() {
    Color color = AppTheme.adjustmentColor;
    if (widget.transaction.transactionType == TransactionType.Income)
      color = AppTheme.incomeColor;
    else if (widget.transaction.transactionType == TransactionType.Expense)
      color = AppTheme.expenseColor;
    else if (widget.transaction.transactionType == TransactionType.Adjustment)
      color = AppTheme.adjustmentColor;
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction.tag.name,
        ),
        backgroundColor: _pageThemeColor(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Text(DateFormat(AppTheme.dateTimeFormat).format(
                  widget.transaction.dateTime,
                )),
              ),
              SizedBox(
                height: 5,
              ),
              Text.rich(
                TextSpan(
                    text: widget.transaction.balanceChange ==
                            BalanceChange.Icrement
                        ? '+'
                        : '-',
                    style: TextStyle(
                      color: widget.transaction.balanceChange ==
                              BalanceChange.Icrement
                          ? AppTheme.amountIcrementColor
                          : AppTheme.amountDecrementColor,
                      fontSize: 26,
                    ),
                    children: [
                      TextSpan(
                          text: ' Rs. ${widget.transaction.amount.toString()}')
                    ]),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _descriptionTextController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(
                    color: _pageThemeColor(),
                    fontSize: 20,
                  ),
                  hintText:
                      'Enter detail about this ${getEnumStringValue(widget.transaction.transactionType.toString())}',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _pageThemeColor(),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _pageThemeColor(),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _pageThemeColor(),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _pageThemeColor(),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _pageThemeColor(),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                minLines: 3,
                maxLines: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
