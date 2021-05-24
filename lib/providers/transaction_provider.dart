import 'package:flutter/cupertino.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/helpers/local_db_helper.dart';
import 'package:little_pocket/models/mini_transaction.dart';
import 'package:little_pocket/models/tag.dart';
import 'package:little_pocket/models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _myTransactions = [];
  List<Transaction> _dummyTransactions = [
    Transaction(
      id: 1,
      tag: Tag(
        id: 2,
        name: 'Papa',
      ),
      amount: 2500,
      transactionType: TransactionType.Income,
      balanceChange: BalanceChange.Icrement,
      description: 'For buying utilities',
      dateTime: DateTime.now(),
    ),
    Transaction(
        id: 4,
        tag: Tag(
          id: 2,
          name: 'Bill Payment',
        ),
        amount: 1500,
        transactionType: TransactionType.Expense,
        balanceChange: BalanceChange.Decrement,
        description: 'Paid for electricity bill',
        dateTime: DateTime.now(),
        miniTransactionList: [
          MiniTransaction(
            id: 5,
            name: 'Electricity',
            amount: 700,
            balanceChange: BalanceChange.Decrement,
          ),
          MiniTransaction(
            id: 2,
            name: 'PTCL',
            amount: 900,
            balanceChange: BalanceChange.Decrement,
          ),
          MiniTransaction(
            id: 2,
            name: 'Discount',
            amount: 100,
            balanceChange: BalanceChange.Icrement,
          ),
        ]),
    Transaction(
      id: 2,
      tag: Tag(
        id: 2,
        name: 'Bought Utilities',
      ),
      amount: 300,
      transactionType: TransactionType.Expense,
      balanceChange: BalanceChange.Decrement,
      description: 'Utilites purchased from market',
      dateTime: DateTime.now(),
    ),
    Transaction(
      id: 2,
      tag: Tag(
        id: 1,
        name: 'Adjustment',
      ),
      amount: 150,
      transactionType: TransactionType.Adjustment,
      balanceChange: BalanceChange.Icrement,
      dateTime: DateTime.now(),
    ),
    Transaction(
      id: 1,
      tag: Tag(
        id: 1,
        name: 'Bank',
      ),
      amount: 2000,
      transactionType: TransactionType.Income,
      balanceChange: BalanceChange.Icrement,
      dateTime: DateTime.now(),
    ),
  ];

  List<Transaction> get myTransactions {
    _dummyTransactions.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return _dummyTransactions;
  }

  Future<void> fetchTransactions() async {
    try {
      var transactionsFetched = await LocalDatabase.getTransactions();
      print('fetched Transactions: ');
      transactionsFetched.forEach((element) {
        print(element);
      });
    } catch (error) {
      print('error from fetchTransactions: \n$error');
      throw error;
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      int transactionId =
          await LocalDatabase.insert('transactions', transaction.toMap());
      for (int i = 0; i < transaction.miniTransactionList.length; i++) {
        await LocalDatabase.insert(
          'mini_transactions',
          transaction.miniTransactionList[i].toMap(transactionId),
        );
      }
      await fetchTransactions();
      // _myTransactions.add(transaction);
      // notifyListeners();
    } catch (error) {
      print('error from addTransaction: \n$error');
      throw error;
    }
  }

  Future<void> editTransaction() async {}
  Future<void> removeTransaction() async {}
}
