import 'package:intl/intl.dart';

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

  Map<String, dynamic> toMap() {
    var mapObj = {
      'tagId': tag.id,
      'dateTime': dateTime.toIso8601String(),
      'amount': amount,
      'transactionType': transactionType.toString(),
      'balanceChange': balanceChange.toString(),
      'description': description,
    };
    return mapObj;
  }

  static Transaction fromMap(Map<String, dynamic> transObj) {
    Transaction transaction = Transaction(
      id: transObj['id'],
      tag: Tag(
        id: transObj['tagId'],
      ),
      dateTime: DateFormat('yyyy-MM-ddThh:mm:ss', 'en_US')
          .parse(transObj['dateTime']),
      amount: transObj['amount'],
      transactionType: getEnumValue(
        type: EnumType.TransactionType,
        enumString: transObj['transactionType'],
      ),
      balanceChange: getEnumValue(
        type: EnumType.BalanceChange,
        enumString: transObj['balanceChange'],
      ),
      description: transObj['description'],
    );
    return transaction;
  }
}
