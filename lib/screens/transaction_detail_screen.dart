import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:little_pocket/helpers/configurations.dart';
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
    _descriptionTextController.text = widget.transaction.description.length == 0
        ? 'No description.'
        : widget.transaction.description;
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

  var tableItem = (Widget textWidget) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: textWidget,
      );

  List<TableRow> _buildMiniTableContent() {
    return widget.transaction.miniTransactionList
        .map((miniTransaction) => TableRow(children: [
              tableItem(Text('${miniTransaction.name}')),
              tableItem(Text('Rs. ${miniTransaction.amount.toString()}')),
              tableItem(Text(
                miniTransaction.balanceChange == BalanceChange.Icrement
                    ? '+'
                    : '-',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: miniTransaction.balanceChange == BalanceChange.Icrement
                      ? AppTheme.amountIcrementColor
                      : AppTheme.amountDecrementColor,
                ),
                textAlign: TextAlign.center,
              ))
            ]))
        .toList();
  }

  Widget _buildMiniTable() {
    return Container(
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(13),
          labelText: 'Mini Table',
          labelStyle: TextStyle(
            color: _pageThemeColor(),
            fontSize: 20,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: _pageThemeColor(),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _pageThemeColor(),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Table(
          columnWidths: {2: FlexColumnWidth(0.4)},
          border: TableBorder.symmetric(
            inside: BorderSide(
              color: Colors.black26,
              style: BorderStyle.solid,
            ),
          ),
          children: [
            TableRow(
              children: [
                tableItem(Text(
                  'Item',
                  style: AppTheme.miniTableHeadingStyle
                      .copyWith(color: _pageThemeColor()),
                  textAlign: TextAlign.center,
                )),
                tableItem(Text(
                  'Amount',
                  style: AppTheme.miniTableHeadingStyle
                      .copyWith(color: _pageThemeColor()),
                  textAlign: TextAlign.center,
                )),
                tableItem(Text(
                  '+ / -',
                  style: AppTheme.miniTableHeadingStyle
                      .copyWith(color: _pageThemeColor()),
                  textAlign: TextAlign.center,
                )),
              ],
            ),
            ..._buildMiniTableContent(),
          ],
        ),
      ),
    );
  }

  Widget _description() {
    return TextField(
      controller: _descriptionTextController,
      enabled: false,
      decoration: AppTheme.inputDecoration(_pageThemeColor()).copyWith(
        labelText: 'Description',
        hintText:
            'Enter detail about this ${getEnumStringValue(widget.transaction.transactionType.toString())}',
      ),
      minLines: 3,
      maxLines: 15,
    );
  }

  bool _isEditable() {
    DateTime profileViewDateTime = widget.transaction.dateTime;
    int diffInSeconds =
        DateTime.now().difference(profileViewDateTime).inSeconds;
    if (diffInSeconds < Configs.thresholdEditableSeconds) {
      return true;
    } else
      return false;
  }

  Future<void> _onEditPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction.tag.name,
        ),
        backgroundColor: _pageThemeColor(),
        actions: [
          if (_isEditable())
            IconButton(icon: Icon(Icons.edit), onPressed: _onEditPressed)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  DateFormat(AppTheme.dateTimeFormat).format(
                    widget.transaction.dateTime,
                  ),
                  textAlign: TextAlign.right,
                ),
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
              _description(),
              SizedBox(
                height: 15,
              ),
              if (widget.transaction.miniTransactionList.isNotEmpty)
                _buildMiniTable(),
            ],
          ),
        ),
      ),
    );
  }
}
