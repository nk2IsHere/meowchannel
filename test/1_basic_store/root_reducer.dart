import 'package:meowchannel/meowchannel.dart';

import 'root_actions.dart';
import 'root_state.dart';


final Reducer<RootState> rootReducer =
  typedReducer<RootAction, RootState>(syncedReducer<RootAction, RootState>((RootAction action, RootState previousState) {
    return previousState.copyWith(
      value: action is RootIncreaseAction? previousState.value + 1 
        : action is RootDecreaseAction? previousState.value - 1 
        : previousState.value
    );
  }));
