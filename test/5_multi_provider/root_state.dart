import 'package:dataclass_beta/dataclass_beta.dart';

part 'root_state.g.dart';

@DataClass()
class FirstRootState with _$FirstRootState {
  final int value;

  FirstRootState({
    required this.value
  });
}

@DataClass()
class SecondRootState with _$SecondRootState {
  final int value;

  SecondRootState({
    required this.value
  });
}
