class Validation {
  static checkValidDecimalAmount(String value) {
    return RegExp(r"^[0-9]\d*(\.\d+)?$").hasMatch(value);
  }

  static checkValidAmount(String value) {
    return RegExp(r"^[0-9]*$").hasMatch(value);
  }
}
