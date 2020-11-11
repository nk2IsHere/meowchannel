import 'package:dataclass_beta/dataclass_beta.dart';

part 'root_state.g.dart';

@dataClass
class RootState extends _$RootState {
  final int value;

  RootState({
    this.value
  });
}