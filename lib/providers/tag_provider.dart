import 'package:flutter/cupertino.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/models/tag.dart';

class TagProvider with ChangeNotifier {
  List<Tag> _incomeTags = [];
  List<Tag> _expenseTags = [];

  List<Tag> _incomeTagsDummy = [
    Tag(
      id: '2',
      name: 'Papa',
    ),
    Tag(
      id: '2',
      name: 'Bank Withdrawl',
    ),
    Tag(
      id: '2',
      name: 'Jazz Cash',
    ),
    Tag(
      id: '2',
      name: 'Adjustment',
    ),
  ];

  List<Tag> _expenseTagsDummy = [
    Tag(
      id: '2',
      name: 'Bill Payments',
    ),
    Tag(
      id: '2',
      name: 'Mobile Recharge',
    ),
    Tag(
      id: '2',
      name: 'Bought Utilities',
    ),
    Tag(
      id: '2',
      name: 'Adjustment',
    ),
  ];

  List<Tag> get incomeTags {
    return _incomeTagsDummy;
  }

  List<Tag> get expenseTags {
    return _expenseTagsDummy;
  }

  Future<void> fetchTags(TagType tagType) async {
    // fetch Adjustment Tag along with Income / Expense Tags
  }

  Future<Tag> getAdjustmentTagOnly() async {
    return Tag(id: '1', name: 'Adjustment dummy');
  }
}
