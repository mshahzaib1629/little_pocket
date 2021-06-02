import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:little_pocket/helpers/configurations.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/helpers/local_db_helper.dart';
import 'package:little_pocket/helpers/styling.dart';
import 'package:little_pocket/models/tag.dart';
import 'package:little_pocket/models/transaction.dart';
import 'package:little_pocket/providers/tag_provider.dart';
import 'package:little_pocket/providers/transaction_provider.dart';
import 'package:little_pocket/screens/add_transaction_screen.dart';
import 'package:little_pocket/screens/app_drawer.dart';
import 'package:little_pocket/widgets/default_error_dialog.dart';
import 'package:little_pocket/widgets/history_card.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isLoading = false, upDirection = true, flag = true;
  List<Transaction> _filteredTransactions = [];
  final _transactionSearchController = TextEditingController();
  ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _fetchTransactions();
    _controller = ScrollController()
      ..addListener(() {
        upDirection =
            _controller.position.userScrollDirection == ScrollDirection.forward;
        if (upDirection != flag) setState(() {});

        flag = upDirection;
      });
  }

  Future<void> _fetchTransactions() async {
    try {
      final transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);
      setState(() {
        _isLoading = true;
      });
      await transactionProvider.fetchTransactions().then((value) async {
        final tagProvider = Provider.of<TagProvider>(context, listen: false);
        if (await tagProvider.getAdjustmentTagOnly() == null) {
          Tag adjustmentTag = Tag(
            name: 'Adjustment',
            tagType: TagType.Adjustment,
            lastTimeUsed: DateTime.now(),
            isActive: true,
          );
          await LocalDatabase.insert('tags', adjustmentTag.toMap());
          print('adjustmentTag added');
        }
      });
    } catch (error) {
      print('error from _fetchTransactions: \n$error');
      showDefaultErrorMsg(context, content: error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _confirmDismiss(
      DismissDirection direction, Transaction transaction) async {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                  'Sure to delete ${transaction.tag.name}?\nThis action can not be undone!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: _dismissibleColor(transaction),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: _dismissibleColor(transaction),
                    ),
                  ),
                ),
              ],
            ));
  }

  void _onDismissed(DismissDirection direction, Transaction transaction) {
    try {
      print('_onDismissed is called');
      final transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);
      transactionProvider.removeTransaction(transaction);
    } catch (error) {
      print('error from _onDismissed: \n$error');
      showDefaultErrorMsg(context);
    }
  }

  Color _dismissibleColor(Transaction transaction) {
    Color color = AppTheme.adjustmentColor;
    if (transaction.transactionType == TransactionType.Income)
      color = AppTheme.incomeColor;
    else if (transaction.transactionType == TransactionType.Expense)
      color = AppTheme.expenseColor;
    else if (transaction.transactionType == TransactionType.Adjustment)
      color = AppTheme.adjustmentColor;
    return color;
  }

  List<HawkFabMenuItem> _floatButtonMenuList(context) => [
        HawkFabMenuItem(
          label: 'Income',
          ontap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(
                transactionType: TransactionType.Income,
                accessedFor: ArthmeticOperation.Add,
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
                transactionType: TransactionType.Expense,
                accessedFor: ArthmeticOperation.Add,
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
                transactionType: TransactionType.Adjustment,
                accessedFor: ArthmeticOperation.Add,
              ),
            ),
          ),
          icon: Icon(AppTheme.adjustmentIcon),
          color: AppTheme.adjustmentColor,
          labelColor: Colors.black,
        ),
      ];

  List<Widget> _buildTransactionCards(List<Transaction> transactions) {
    return transactions
        .map(
          (trans) => Configs.isEditable(trans)
              ? Dismissible(
                  key: Key(trans.id.toString()),
                  confirmDismiss: (direction) =>
                      _confirmDismiss(direction, trans),
                  background: Container(
                    color: _dismissibleColor(
                      trans,
                    ),
                  ),
                  onDismissed: (direction) => _onDismissed(direction, trans),
                  child: Column(
                    children: [
                      HistoryCard(trans),
                      // if (index != _transactions.length - 1)
                      Divider(
                        height: 0,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    HistoryCard(trans),
                    // if (index != _transactions.length - 1)
                    Divider(
                      height: 0,
                      color: Colors.black26,
                    ),
                  ],
                ),
        )
        .toList();
  }

  @override
  // original build func
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Little Pocket'),
      ),
      drawer: AppDrawer(),
      body: HawkFabMenu(
        items: _floatButtonMenuList(context),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<TransactionProvider>(
                builder: (context, transactionConsumer, _) {
                  List<Transaction> _transactions =
                      transactionConsumer.myTransactions;
                  return _transactions.length == 0
                      ? RefreshIndicator(
                          onRefresh: _fetchTransactions,
                          child: ListView(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 2.5,
                              ),
                              Center(
                                child: Text(
                                  'Seems no record exists!',
                                  style: AppTheme.emptyPageTextStyle,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            if (upDirection)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4,
                                ),
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.15),
                                child: TextField(
                                  controller: _transactionSearchController,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.search,
                                  onChanged: (value) {
                                    setState(() {
                                      _filteredTransactions = [];
                                    });
                                    _transactions.forEach((element) {
                                      if (element.tag.name
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                        setState(() {
                                          _filteredTransactions.add(element);
                                        });
                                    });
                                  },
                                  decoration: AppTheme.inputDecoration(
                                          Theme.of(context).accentColor)
                                      .copyWith(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: 'Search here',
                                    labelStyle: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: _fetchTransactions,
                                child: ListView(
                                  controller: _controller,
                                  children: [
                                    ..._buildTransactionCards(
                                        _transactionSearchController
                                                .text.isEmpty
                                            ? _transactions
                                            : _filteredTransactions),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                },
              ),
      ),
    );
  }
}
