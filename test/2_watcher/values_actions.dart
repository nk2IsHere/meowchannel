import 'package:meowchannel/meowchannel.dart';

class ValuesAction extends Action {}

class ValuesAddValueAction extends ValuesAction {
  final String value;

  ValuesAddValueAction({
    this.value
  });
}

class ValuesTesterAction extends Action {}

class ValuesTesterAddValueAction extends ValuesTesterAction {
  final String value;

  ValuesTesterAddValueAction({
    this.value
  });
}