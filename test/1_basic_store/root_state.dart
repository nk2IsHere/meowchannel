import 'package:dataclass_beta/dataclass_beta.dart';

part 'root_state.g.dart';

@DataClass()
class RootState with _$RootState {
  final int value;

  RootState({
    required this.value
  });
}
