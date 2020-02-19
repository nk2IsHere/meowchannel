import 'package:meowflux/core/action.dart';
import 'package:meowflux/core/reducer.dart';
import 'package:meowflux/meowflux.dart';

import 'root_actions.dart';
import 'root_state.dart';


final Reducer<RootState> rootReducer =
  TypedReducer(RootState(value: 0), (RootAction action, RootState previousState) {    
    return previousState.copyWith(
      value: action is RootIncreaseAction? previousState.value + 1 
        : action is RootDescreaseAction? previousState.value - 1 
        : previousState.value
    );
  });