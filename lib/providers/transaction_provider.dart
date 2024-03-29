import 'package:flutter/cupertino.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/helpers/local_db_helper.dart';
import 'package:little_pocket/models/mini_transaction.dart';
import 'package:little_pocket/models/tag.dart';
import 'package:little_pocket/models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _myTransactions = [];

  List<Transaction> get myTransactions {
    _myTransactions.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return _myTransactions.reversed.toList();
  }

  Future<void> fetchTransactions() async {
    try {
      List<Transaction> transactionsParsed = [];
      var transactionsFetched = await LocalDatabase.getTransactions();
      for (int i = 0; i < transactionsFetched.length; i++) {
        // print(transactionsFetched[i]);
        var transaction = Transaction.fromMap(transactionsFetched[i]);
        var miniTransactionsFetched =
            await LocalDatabase.getMiniTransactions(transaction.id);
        transaction.miniTransactionList = miniTransactionsFetched
            .map((miniTrans) => MiniTransaction.fromMap(miniTrans))
            .toList();
        var tagFetched = await LocalDatabase.getTag(transaction.tag.id);
        transaction.tag = Tag.fromMap(tagFetched);
        transactionsParsed.add(transaction);
      }
      _myTransactions = transactionsParsed;
      notifyListeners();
    } catch (error) {
      print('error from fetchTransactions: \n$error');
      throw error;
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      List<MiniTransaction> newlyMiniTransactionList = [];
      int transactionId =
          await LocalDatabase.insert('transactions', transaction.toMap());
      transaction.id = transactionId;
      for (int i = 0; i < transaction.miniTransactionList.length; i++) {
        transaction.miniTransactionList[i].id = await LocalDatabase.insert(
          'mini_transactions',
          transaction.miniTransactionList[i].toMap(transactionId),
        );
        newlyMiniTransactionList.add(transaction.miniTransactionList[i]);
      }
      Tag selectedTag = transaction.tag;
      selectedTag.lastTimeUsed = DateTime.now();
      await LocalDatabase.update('tags', selectedTag.id, selectedTag.toMap());
      transaction.miniTransactionList = newlyMiniTransactionList;
      _myTransactions.add(transaction);
      notifyListeners();
    } catch (error) {
      print('error from addTransaction: \n$error');
      throw error;
    }
  }

  Future<void> updateTransaction(Transaction transaction,
      List<MiniTransaction> deletedMiniTransactions) async {
    try {
      // adding and updating mini_transactions
      for (int i = 0; i < transaction.miniTransactionList.length; i++) {
        var miniTrans = transaction.miniTransactionList[i];
        if (miniTrans.id == null)
          transaction.miniTransactionList[i].id = await LocalDatabase.insert(
              'mini_transactions', miniTrans.toMap(transaction.id));
        // add this to local miniTransList's targeted item in this transaction locally
        else
          await LocalDatabase.update('mini_transactions', miniTrans.id,
              miniTrans.toMap(transaction.id));
      }
      // deleting mini_transactions
      for (int d = 0; d < deletedMiniTransactions.length; d++) {
        var miniTransToDelete = deletedMiniTransactions[d];
        await LocalDatabase.delete(
          'mini_transactions',
          miniTransToDelete.id,
        );
      }
      // updating transaction detail
      await LocalDatabase.update(
          'transactions', transaction.id, transaction.toMap());
      int targetedIndex =
          _myTransactions.indexWhere((trans) => trans.id == transaction.id);
      _myTransactions[targetedIndex] = transaction;
      notifyListeners();
    } catch (error) {
      print('error from updateTransaction: \n$error');
      throw error;
    }
  }

  Future<void> removeTransaction(Transaction transaction) async {
    try {
      await LocalDatabase.deleteMiniTransactions(transaction.id);
      await LocalDatabase.delete('transactions', transaction.id);
      _myTransactions.remove(transaction);
      notifyListeners();
    } catch (error) {
      print('error from removeTransaction: \n$error');
      throw error;
    }
  }
}
