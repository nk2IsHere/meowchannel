import 'package:meowchannel/meowchannel.dart';

class ValuesAction {}

class ValuesAddValueAction extends ValuesAction {
  final String value;

  ValuesAddValueAction({
    this.value
  });
}

class ValuesTesterAction {}

class ValuesTesterAddValueAction extends ValuesTesterAction {
  final String value;

  ValuesTesterAddValueAction({
    this.value
  });
}