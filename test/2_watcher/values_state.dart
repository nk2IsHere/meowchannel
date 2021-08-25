import 'package:dataclass_beta/dataclass_beta.dart';

part 'values_state.g.dart';

@DataClass()
class ValuesState with _$ValuesState {
  final List<String> values;

  ValuesState({
    this.values
  });
}