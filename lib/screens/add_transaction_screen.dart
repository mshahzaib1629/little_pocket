import 'package:flutter/material.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/helpers/styling.dart';
import 'package:little_pocket/models/mini_transaction.dart';
import 'package:little_pocket/models/tag.dart';
import 'package:little_pocket/providers/tag_provider.dart';
import 'package:little_pocket/widgets/add_mini_transaction_button.dart';
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
  Tag _selectedTag;

  List<MiniTransaction> _miniTransactionList = [];
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
      child: ExpansionTile(
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
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountTextController,
      decoration: AppTheme.inputDecoration(_pageThemeColor()).copyWith(
        labelText: 'Amount in Rupees',
      ),
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
              )),
              tableItem(InkWell(
                onTap: () {},
                child: Icon(
                  Icons.edit,
                  color: _pageThemeColor(),
                  size: 16,
                ),
              )),
            ]))
        .toList();
  }

  void _addToMiniList(MiniTransaction miniTransaction) {
    setState(() {
      _miniTransactionList.add(miniTransaction);
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
                child: AddMiniTransactionButton(
                  addToList: _addToMiniList,
                ))
            : Table(
                columnWidths: {
                  2: FlexColumnWidth(0.4),
                  3: FlexColumnWidth(0.2),
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
                          size: 16,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Add ${getEnumStringValue(widget.transactionType.toString())}'),
        backgroundColor: _pageThemeColor(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.transactionType != TransactionType.Adjustment)
                _buildTags(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    _buildMiniTable(),
                    if (_miniTransactionList.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Theme(
                            data: Theme.of(context)
                                .copyWith(accentColor: _pageThemeColor()),
                            child: AddMiniTransactionButton(
                              addToList: _addToMiniList,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
