import 'package:little_pocket/models/transaction.dart';

class Configs {
  // 172800 = 2 Days
  static int thresholdEditableSeconds = 172800;

  static bool isEditable(Transaction transaction) {
    DateTime profileViewDateTime = transaction.dateTime;
    int diffInSeconds =
        DateTime.now().difference(profileViewDateTime).inSeconds;
    if (diffInSeconds < Configs.thresholdEditableSeconds) {
      return true;
    } else
      return false;
  }
}
