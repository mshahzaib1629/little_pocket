import '../helpers/enums.dart';
import './mini_transaction.dart';
import 'tag.dart';

class Transaction {
  int id;
  Tag tag;
  DateTime dateTime;
  double amount;
  TransactionType transactionType;
  BalanceChange balanceChange;
  List<MiniTransaction> miniTransactionList;
  String description;

  Transaction({
    this.id,
    this.tag,
    this.dateTime,
    this.amount,
    this.balanceChange,
    this.miniTransactionList,
    this.transactionType,
    this.description,
  });
}
