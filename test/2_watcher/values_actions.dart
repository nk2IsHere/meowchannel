import 'package:dataclass/dataclass.dart';
import 'package:meowflux/core/action.dart';

part 'values_actions.g.dart';

class ValuesAction extends Action {}

@dataClass
class ValuesAddValueAction extends _$ValuesAddValueAction {
  final String value;

  ValuesAddValueAction({
    this.value
  });
}

class ValuesTesterAction extends Action {}

@dataClass
class ValuesTesterAddValueAction extends _$ValuesTesterAddValueAction {
  final String value;

  ValuesTesterAddValueAction({
    this.value
  });
}