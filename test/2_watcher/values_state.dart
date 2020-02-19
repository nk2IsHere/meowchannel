import 'package:dataclass/dataclass.dart';

part 'values_state.g.dart';

@dataClass
class ValuesState extends _$ValuesState {
  final List<String> values;

  ValuesState({
    this.values
  });
}