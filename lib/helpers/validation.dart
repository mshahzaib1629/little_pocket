class Validation {
  static checkValidAmount(String value) {
    return RegExp(r"^[0-9]\d*(\.\d+)?$").hasMatch(value);
  }
}
