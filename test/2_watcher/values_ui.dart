

//
// I can show values!
//
class ValuesUi {
  String _values = "";

  void showValue(String value) {
    this._values = this._values + (value ?? "");
  }

  String render() {
    return _values;
  }
}