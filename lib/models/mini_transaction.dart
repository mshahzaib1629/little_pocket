import 'package:little_pocket/helpers/enums.dart';

class MiniTransaction {
  int id;
  String name;
  double amount;
  BalanceChange balanceChange;

  MiniTransaction({
    this.id,
    this.name,
    this.amount,
    this.balanceChange,
  });

  @override
  String toString() {
    return '{id: $id, name: $name, amount: $amount, balanceChange: ${balanceChange.toString()}}';
  }

  static Map<String, dynamic> toMap(
      MiniTransaction miniTransaction, String transactionId) {
    return {
      'transactionId': transactionId,
      'name': miniTransaction.name,
      'amount': miniTransaction.amount,
      'balanceChange': miniTransaction.balanceChange.toString(),
    };
  }
}
