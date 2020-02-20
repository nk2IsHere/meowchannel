import 'package:meowflux/core/action.dart';
import 'package:meowflux/core/reducer.dart';
import 'package:meowflux/meowflux.dart';

import 'root_actions.dart';
import 'root_state.dart';


final Reducer<RootState> RootReducer =
  TypedReducer<RootAction, RootState>(RootState(value: 0), (RootAction action, RootState previousState) {    
    return previousState.copyWith(
      value: action is RootIncreaseAction? previousState.value + 1 
        : action is RootDecreaseAction? previousState.value - 1 
        : previousState.value
    );
  });