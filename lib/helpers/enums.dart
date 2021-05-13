import 'package:little_pocket/models/transaction.dart';

enum TransactionType {
  Income,
  Expense,
  Adjustment,
}

enum BalanceChange {
  Icrement,
  Decrement,
}

enum TagType {
  Income,
  Expense,
  Adjustment,
}

enum EnumType {
  TransactionType,
  BalanceChange,
  TagType,
}

// To convert String value (enum) to enum value
dynamic getEnumValue({EnumType type, String enumString}) {
  if (type == EnumType.TransactionType) {
    for (int i = 0; i < TransactionType.values.length; i++) {
      if (enumString == TransactionType.values[i].toString()) {
        return TransactionType.values[i];
      }
    }
  } else if (type == EnumType.BalanceChange) {
    for (int i = 0; i < BalanceChange.values.length; i++) {
      if (enumString == BalanceChange.values[i].toString()) {
        return BalanceChange.values[i];
      }
    }
  } else if (type == EnumType.TagType) {
    for (int i = 0; i < TagType.values.length; i++) {
      if (enumString == TagType.values[i].toString()) {
        return TagType.values[i];
      }
    }
  }
}

String getEnumStringValue(String enumString) {
  String enumValueString = enumString.split('.')[1];
  String normalizedString = enumValueString[0];
  RegExp regExp = RegExp('[A-Z]');
  for (int i = 1; i < enumValueString.length; i++) {
    if (regExp.hasMatch(enumValueString[i])) {
      normalizedString = normalizedString + ' ';
    }
    normalizedString = normalizedString + enumValueString[i];
  }

  return normalizedString;
}
