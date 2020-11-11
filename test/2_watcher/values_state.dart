import 'package:dataclass_beta/dataclass_beta.dart';

part 'values_state.g.dart';

@dataClass
class ValuesState extends _$ValuesState {
  final List<String> values;

  ValuesState({
    this.values
  });
}