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

class ValuesUiAction extends Action {}

@dataClass
class ValuesUiAddValueAction extends _$ValuesUiAddValueAction {
  final String value;

  ValuesUiAddValueAction({
    this.value
  });
}