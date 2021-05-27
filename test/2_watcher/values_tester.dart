

//
// I can show values!
//
class ValuesTester {
  String _values = "";

  void showValue(String value) {
    this._values = this._values + (value);
  }

  String render() {
    return _values;
  }
}
