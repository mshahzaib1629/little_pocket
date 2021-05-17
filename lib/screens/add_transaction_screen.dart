import 'package:flutter/material.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/helpers/styling.dart';
import 'package:little_pocket/models/tag.dart';
import 'package:little_pocket/providers/tag_provider.dart';
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
      decoration: InputDecoration(
        labelText: 'Amount in Rupees',
        labelStyle: TextStyle(
          color: _pageThemeColor(),
          fontSize: 20,
        ),
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
      keyboardType: TextInputType.number,
      minLines: 1,
      maxLines: 1,
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionTextController,
      decoration: InputDecoration(
        labelText: 'Description',
        labelStyle: TextStyle(
          color: _pageThemeColor(),
          fontSize: 20,
        ),
        hintText:
            'Enter detail about this ${getEnumStringValue(widget.transactionType.toString())}',
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
      textCapitalization: TextCapitalization.sentences,
      minLines: 3,
      maxLines: 15,
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
