import 'package:flutter/material.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/helpers/styling.dart';
import 'package:little_pocket/models/mini_transaction.dart';
import '../helpers/validation.dart';

class MiniTransactionButton extends StatelessWidget {
  final _itemNameController = TextEditingController();
  final _itemAmountController = TextEditingController();
  final _amountFocusNode = FocusNode();

  final Function(MiniTransaction miniTransaction) addToList;
  final Function({MiniTransaction miniTrans, ArthmeticOperation operation})
      editOrDelete;
  final ArthmeticOperation operationType;
  final String buttonTitle;

  String orignalItemName;
  String orignalAmount;
  BalanceChange originalBalanceChange;
  MiniTransactionButton({
    this.addToList,
    this.editOrDelete,
    this.buttonTitle,
    balanceChange,
    @required this.operationType,
    String itemName,
    double amount,
  }) {
    if (operationType == ArthmeticOperation.Edit) {
      orignalItemName = itemName;
      orignalAmount = amount.toStringAsFixed(0);
    }
    if (balanceChange != null) {
      originalBalanceChange = balanceChange;
    }
    _itemNameController.text = orignalItemName;
    _itemAmountController.text = orignalAmount;
  }

  void _saveForm(context, balanceChange) {
    MiniTransaction miniTransaction = MiniTransaction(
      name: _itemNameController.text,
      amount: double.parse(_itemAmountController.text),
      balanceChange: balanceChange,
    );
    // if (_key.currentState.validate()) {
    if (operationType == ArthmeticOperation.Add)
      addToList(miniTransaction);
    else
      editOrDelete(
        miniTrans: miniTransaction,
        operation: ArthmeticOperation.Edit,
      );
    _itemNameController.text = '';
    _itemAmountController.text = '';
    Navigator.pop(context);
    // }
  }

  void _onTap(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final _key = GlobalKey<FormState>();
          BalanceChange _balanceChange = originalBalanceChange;
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Text('Mini Transaction'),
              content: Container(
                height: 150,
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
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_amountFocusNode),
                        decoration: AppTheme.inputDecoration(
                                Theme.of(context).accentColor)
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
                        focusNode: _amountFocusNode,
                        cursorColor: Theme.of(context).accentColor,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Amount should not be empty!';
                          else if (!Validation.checkValidAmount(value))
                            return 'Enter valid amount!';
                          return null;
                        },
                        decoration: AppTheme.inputDecoration(
                                Theme.of(context).accentColor)
                            .copyWith(
                          suffix: IconButton(
                              icon: _balanceChange == BalanceChange.Icrement
                                  ? Icon(
                                      Icons.add,
                                      color: AppTheme.amountIcrementColor,
                                      size: 18,
                                    )
                                  : Icon(
                                      Icons.remove,
                                      color: AppTheme.amountDecrementColor,
                                      size: 18,
                                    ),
                              onPressed: () {
                                if (_balanceChange == BalanceChange.Icrement)
                                  setState(() {
                                    _balanceChange = BalanceChange.Decrement;
                                  });
                                else
                                  setState(() {
                                    _balanceChange = BalanceChange.Icrement;
                                  });
                                print(_balanceChange.toString());
                              }),
                          labelText: 'Amount in Rupees',
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
                if (operationType == ArthmeticOperation.Edit)
                  TextButton(
                    onPressed: () {
                      editOrDelete(operation: ArthmeticOperation.Delete);
                      _itemNameController.text = '';
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    // editOrDelete(miniTransaction, ArthmeticOperation.Edit);
                    if (operationType == ArthmeticOperation.Edit) {
                      _itemNameController.text = orignalItemName;
                      _itemAmountController.text = orignalAmount;
                      _balanceChange = originalBalanceChange;
                    } else {
                      _itemNameController.text = '';
                      _itemAmountController.text = '';
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if ((_key.currentState.validate()))
                      _saveForm(context, _balanceChange);
                  },
                  child: Text(
                    operationType == ArthmeticOperation.Add ? 'Add' : 'Edit',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return operationType == ArthmeticOperation.Add
        ? ElevatedButton(
            onPressed: () => _onTap(context),
            child: Text(
              buttonTitle,
              textAlign: TextAlign.left,
            ),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).accentColor.withOpacity(0.8),
              shadowColor: Colors.transparent,
            ),
          )
        : InkWell(
            onTap: () => _onTap(context),
            child: Icon(
              Icons.edit,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
          );
  }
}
