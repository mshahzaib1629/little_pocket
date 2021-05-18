import 'package:flutter/material.dart';
import 'package:little_pocket/helpers/styling.dart';
import 'package:little_pocket/models/mini_transaction.dart';

class AddMiniTransactionButton extends StatelessWidget {
  final _key = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _itemAmountController = TextEditingController();
  final Function(MiniTransaction miniTransaction) addToList;

  AddMiniTransactionButton({this.addToList});

  void _addMiniTransaction(context) {
    print(_itemNameController.text);
    MiniTransaction miniTransaction = MiniTransaction(
        name: _itemNameController.text,
        amount: double.parse(_itemAmountController.text));
    addToList(miniTransaction);
    _itemNameController.text = '';
    Navigator.pop(context);
  }

  void _saveForm(context) {
    if (_key.currentState.validate()) {
      _addMiniTransaction(context);
    }
  }

  void _onTap(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mini Transaction'),
        content: Container(
          height: 140,
          child: Form(
            key: _key,
            child: Column(
              children: [
                TextFormField(
                  controller: _itemNameController,
                  cursorColor: Theme.of(context).accentColor,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value.isEmpty) return 'Name should not be empty!';
                    return null;
                  },
                  decoration:
                      AppTheme.inputDecoration(Theme.of(context).accentColor)
                          .copyWith(
                    labelText: 'Item Name',
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                    ),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _itemAmountController,
                  cursorColor: Theme.of(context).accentColor,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) return 'Amount should not be empty!';
                    return null;
                  },
                  decoration:
                      AppTheme.inputDecoration(Theme.of(context).accentColor)
                          .copyWith(
                    labelText: 'Amount',
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                    ),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _itemNameController.text = '';
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ),
          TextButton(
            onPressed: () => _saveForm(context),
            child: Text(
              'Add',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _onTap(context),
      child: Text(
        'Add Mini Transaction',
        textAlign: TextAlign.left,
      ),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).accentColor.withOpacity(0.5),
        shadowColor: Colors.transparent,
      ),
    );
  }
}
