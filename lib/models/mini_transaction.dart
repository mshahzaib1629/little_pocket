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

  Map<String, dynamic> toMap(int transactionId) {
    return {
      'transactionId': transactionId,
      'name': name,
      'amount': amount,
      'balanceChange': balanceChange.toString(),
    };
  }

  static MiniTransaction fromMap(Map<String, dynamic> miniObj) {
    MiniTransaction miniTrans = MiniTransaction(
      id: miniObj['id'],
      name: miniObj['name'],
      amount: miniObj['amount'],
      balanceChange: getEnumValue(
        type: EnumType.BalanceChange,
        enumString: miniObj['balanceChange'],
      ),
    );
    return miniTrans;
  }
}
