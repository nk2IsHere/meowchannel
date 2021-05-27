import 'package:meowchannel/meowchannel.dart';

class ValuesAction {}

class ValuesAddValueAction extends ValuesAction {
  final String value;

  ValuesAddValueAction({
    required this.value
  });
}

class ValuesTesterAction {}

class ValuesTesterAddValueAction extends ValuesTesterAction {
  final String value;

  ValuesTesterAddValueAction({
    required this.value
  });
}
