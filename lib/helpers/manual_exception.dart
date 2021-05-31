import 'package:flutter/foundation.dart';

class ManualException implements Exception {
  String message;
  ManualException({@required this.message});
  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpException
  }
}
