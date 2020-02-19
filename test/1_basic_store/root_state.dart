import 'package:dataclass/dataclass.dart';

part 'root_state.g.dart';

@dataClass
class RootState extends _$RootState {
  final int value;

  RootState({
    this.value
  });
}