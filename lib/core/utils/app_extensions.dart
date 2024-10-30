
extension AddZerosToString on String {
  String addZerosToString() {
    if (length == 1) {
      return '000$this';
    } else if (length == 2) {
      return '00$this';
    } else if (length == 3) {
      return "0$this";
    }
    return this;
  }
}
