import 'package:little_pocket/helpers/enums.dart';

class MiniTransaction {
  String id;
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
}
