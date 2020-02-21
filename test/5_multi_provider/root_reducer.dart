import 'package:meowchannel/core/reducer.dart';
import 'package:meowchannel/meowchannel.dart';

import 'root_actions.dart';
import 'root_state.dart';


final Reducer<FirstRootState> FirstRootReducer =
  TypedReducer<FirstRootAction, FirstRootState>(FirstRootState(value: 0), (FirstRootAction action, FirstRootState previousState) {    
    return previousState.copyWith(
      value: action is FirstRootIncreaseAction? previousState.value + 1 
        : action is FirstRootDecreaseAction? previousState.value - 1 
        : previousState.value
    );
  });

final Reducer<SecondRootState> SecondRootReducer =
  TypedReducer<SecondRootAction, SecondRootState>(SecondRootState(value: 0), (SecondRootAction action, SecondRootState previousState) {    
    return previousState.copyWith(
      value: action is SecondRootIncreaseAction? previousState.value + 1 
        : action is SecondRootDecreaseAction? previousState.value - 1 
        : previousState.value
    );
  });