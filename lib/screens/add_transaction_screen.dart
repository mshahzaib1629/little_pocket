import 'package:flutter/material.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/helpers/styling.dart';
import 'package:little_pocket/helpers/validation.dart';
import 'package:little_pocket/models/mini_transaction.dart';
import 'package:little_pocket/models/tag.dart';
import 'package:little_pocket/models/transaction.dart';
import 'package:little_pocket/providers/tag_provider.dart';
import 'package:little_pocket/widgets/mini_transaction_button.dart';
import 'package:little_pocket/widgets/add_tag_button.dart';
import 'package:little_pocket/widgets/tag_card.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionType transactionType;

  AddTransactionScreen(this.transactionType);
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Tag _selectedTag;
  bool _showTagSelectedError = false;
  BalanceChange _balanceChange;

  List<MiniTransaction> _miniTransactionList = [];

  @override
  void initState() {
    super.initState();
    // @TODO
    // if this screen is opened for adding new data
    if (widget.transactionType == TransactionType.Income ||
        widget.transactionType == TransactionType.Adjustment)
      _balanceChange = BalanceChange.Icrement;
    else
      _balanceChange = BalanceChange.Decrement;

    _fetchTags();
  }

  Future<void> _fetchTags() async {
    try {
      final tagProvider = Provider.of<TagProvider>(context, listen: false);

      // after fetching tags, check if transactionType is Adjustment
      if (widget.transactionType != TransactionType.Adjustment) {
        TagType tagType = TagType.Income;
        if (widget.transactionType == TransactionType.Expense)
          tagType = TagType.Expense;
        await tagProvider.fetchTags(tagType);
      } else {
        Tag adjustmentTag = await tagProvider.getAdjustmentTagOnly();
        setState(() {
          _selectedTag = adjustmentTag;
        });
      }
    } catch (error) {
      print('error from _fetchTags: \n$error');
    }
  }

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

  Future<void> _saveForm() async {
    if (_selectedTag != null) {
      setState(() {
        _showTagSelectedError = false;
      });
    } else {
      setState(() {
        _showTagSelectedError = true;
      });
      return;
    }
    if (_formKey.currentState.validate()) {
      print('transactionType: ${widget.transactionType.toString()}');
      print('balanceChange: ${_balanceChange.toString()}');
      print('selectedTag: ${_selectedTag.toString()}');
      print('amount: ${_amountTextController.text}');
      print('description: ${_descriptionTextController.text}');
      print('mini table: ');
      _miniTransactionList.forEach((element) {
        print(element.toString());
      });
    }
  }

  Future<void> addToTagList(Tag tag) async {}

  List<Widget> _getTags(List<Tag> tags, Color highlightedColor) {
    List<Widget> tagsToDisplay = [];

    for (int i = 0; i < tags.length; i++) {
      tagsToDisplay.add(InkWell(
        onTap: () {
          setState(() {
            _selectedTag = tags[i];
          });
        },
        child: TagCard(
          index: i,
          tag: tags[i],
          editable: false,
          isHighlighted: _selectedTag == tags[i],
          highlightedColor: highlightedColor,
        ),
      ));
    }
    tagsToDisplay.add(AddTagButton(addToTagList: addToTagList));
    return tagsToDisplay;
  }

  Widget _tagSet(tags, highlightedColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 5,
      ),
      child: Wrap(
          direction: Axis.horizontal,
          spacing: 5,
          runSpacing: 5,
          alignment: WrapAlignment.start,
          children: _getTags(
            tags,
            highlightedColor,
          )),
    );
  }

  Widget _buildTags() {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        accentColor: _pageThemeColor(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            initiallyExpanded: true,
            title: Text(
                '${getEnumStringValue(widget.transactionType.toString())} Tags'),
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: Consumer<TagProvider>(
                  builder: (context, tagConsumer, _) => _tagSet(
                    widget.transactionType == TransactionType.Income
                        ? tagConsumer.incomeTags
                        : tagConsumer.expenseTags,
                    Theme.of(context).accentColor,
                  ),
                ),
              ),
            ],
          ),
          if (_showTagSelectedError)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                'Please select a tag first',
                style: AppTheme.errorTextStyle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountTextController,
      decoration: AppTheme.inputDecoration(_pageThemeColor()).copyWith(
        labelText: 'Amount in Rupees',
        suffix: widget.transactionType == TransactionType.Adjustment
            ? InkWell(
                child: _balanceChange == BalanceChange.Icrement
                    ? Icon(
                        Icons.add,
                        color: AppTheme.amountIcrementColor,
                        size: 24,
                      )
                    : Icon(
                        Icons.remove,
                        color: AppTheme.amountDecrementColor,
                        size: 24,
                      ),
                onTap: () {
                  if (_balanceChange == BalanceChange.Icrement)
                    setState(() {
                      _balanceChange = BalanceChange.Decrement;
                    });
                  else
                    setState(() {
                      _balanceChange = BalanceChange.Icrement;
                    });
                  print(_balanceChange.toString());
                })
            : null,
      ),
      validator: (value) {
        if (value.isEmpty)
          return 'Amount should not be empty!';
        else if (!Validation.checkValidAmount(value))
          return 'Enter valid amount!';
        return null;
      },
      keyboardType: TextInputType.number,
      minLines: 1,
      maxLines: 1,
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionTextController,
      decoration: AppTheme.inputDecoration(_pageThemeColor()).copyWith(
        labelText: 'Description',
        hintText:
            'Enter detail about this ${getEnumStringValue(widget.transactionType.toString())}',
      ),
      textCapitalization: TextCapitalization.sentences,
      minLines: 3,
      maxLines: 15,
    );
  }

  var tableItem = (Widget textWidget) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: textWidget,
      );

  List<TableRow> _buildMiniTableContent() {
    return _miniTransactionList
        .map((miniTransaction) => TableRow(children: [
              tableItem(Text('${miniTransaction.name}')),
              tableItem(
                  Text('Rs. ${miniTransaction.amount.toStringAsFixed(0)}')),
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
              )),
              tableItem(Theme(
                data:
                    Theme.of(context).copyWith(accentColor: _pageThemeColor()),
                child: MiniTransactionButton(
                  operationType: ArthmeticOperation.Edit,
                  itemName: miniTransaction.name,
                  amount: miniTransaction.amount,
                  balanceChange: miniTransaction.balanceChange,
                  editOrDelete: ({miniTrans, operation}) =>
                      _editOrDeleteMiniTransaction(
                    index: _miniTransactionList.indexOf(miniTransaction),
                    miniTransaction: miniTrans,
                    operation: operation,
                  ),
                ),
              )),
            ]))
        .toList();
  }

  void _editOrDeleteMiniTransaction({
    int index,
    MiniTransaction miniTransaction,
    ArthmeticOperation operation,
  }) {
    if (operation == ArthmeticOperation.Edit)
      setState(() {
        _miniTransactionList[index] = miniTransaction;
      });
    else if (operation == ArthmeticOperation.Delete)
      setState(() {
        _miniTransactionList.removeAt(index);
      });
  }

  void _addToMiniList(MiniTransaction miniTransaction) {
    setState(() {
      _miniTransactionList.add(miniTransaction);
    });
  }

  double _calculateMiniTransactions() {
    double count = 0;
    _miniTransactionList.forEach((mini) {
      count = mini.balanceChange == BalanceChange.Icrement
          ? count + mini.amount
          : count - mini.amount;
    });
    if (_balanceChange == BalanceChange.Decrement) count = -count;
    return count;
  }

  void _onTapAutoCalculate() {
    print('auto calculate taped');
    setState(() {
      _amountTextController.text =
          _calculateMiniTransactions().toStringAsFixed(0);
    });
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
        child: _miniTransactionList.isEmpty
            ? Theme(
                data:
                    Theme.of(context).copyWith(accentColor: _pageThemeColor()),
                child: MiniTransactionButton(
                  buttonTitle: 'Add Mini Transaction',
                  operationType: ArthmeticOperation.Add,
                  addToList: _addToMiniList,
                  balanceChange:
                      widget.transactionType == TransactionType.Expense
                          ? BalanceChange.Decrement
                          : BalanceChange.Icrement,
                ))
            : Table(
                columnWidths: {
                  2: FlexColumnWidth(0.5),
                  3: FlexColumnWidth(0.3),
                },
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
                      tableItem(InkWell(
                        onTap: null,
                        child: Icon(
                          Icons.edit,
                          color: _pageThemeColor(),
                          size: 20,
                        ),
                      )),
                    ],
                  ),
                  ..._buildMiniTableContent(),
                ],
              ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return InkWell(
      onTap: _saveForm,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(color: _pageThemeColor(), boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 5),
            blurRadius: 6,
          ),
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, -5),
            blurRadius: 6,
          ),
        ]),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Save',
              style: AppTheme.formSubmitButtonTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Add ${getEnumStringValue(widget.transactionType.toString())}'),
          backgroundColor: _pageThemeColor(),
        ),
        bottomNavigationBar: _buildBottomButton(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.transactionType != TransactionType.Adjustment)
                  _buildTags(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        _buildAmountField(),
                        SizedBox(
                          height: 15,
                        ),
                        _buildDescriptionField(),
                        SizedBox(
                          height: 15,
                        ),
                        if (widget.transactionType !=
                            TransactionType.Adjustment)
                          _buildMiniTable(),
                        if (_miniTransactionList.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(accentColor: _pageThemeColor()),
                                child: MiniTransactionButton(
                                  buttonTitle: 'Add More',
                                  operationType: ArthmeticOperation.Add,
                                  addToList: _addToMiniList,
                                  balanceChange: widget.transactionType ==
                                          TransactionType.Expense
                                      ? BalanceChange.Decrement
                                      : BalanceChange.Icrement,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              ElevatedButton(
                                onPressed: _calculateMiniTransactions() > 0
                                    ? _onTapAutoCalculate
                                    : null,
                                child: Text(
                                  'Rs. ${_calculateMiniTransactions().toStringAsFixed(0)}',
                                  textAlign: TextAlign.left,
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: _pageThemeColor().withOpacity(0.8),
                                  shadowColor: Colors.transparent,
                                ),
                              )
                            ],
                          ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
