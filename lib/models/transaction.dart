import '../helpers/enums.dart';
import 'tag.dart';

class Transaction {
  String id;
  Tag tag;
  DateTime dateTime;
  double amount;
  TransactionType transactionType;
  BalanceChange balanceChange;
  String description;

  Transaction({
    this.id,
    this.tag,
    this.dateTime,
    this.amount,
    this.balanceChange,
    this.transactionType,
    this.description,
  });
}
