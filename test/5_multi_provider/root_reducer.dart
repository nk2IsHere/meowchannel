import 'package:meowchannel/core/reducer.dart';
import 'package:meowchannel/meowchannel.dart';

import 'root_actions.dart';
import 'root_state.dart';


final Reducer<FirstRootState> firstRootReducer =
  typedReducer<FirstRootAction, FirstRootState>((FirstRootAction action, FirstRootState previousState) {    
    return previousState.copyWith(
      value: action is FirstRootIncreaseAction? previousState.value + 1 
        : action is FirstRootDecreaseAction? previousState.value - 1 
        : previousState.value
    );
  });

final Reducer<SecondRootState> secondRootReducer =
  typedReducer<SecondRootAction, SecondRootState>((SecondRootAction action, SecondRootState previousState) {    
    return previousState.copyWith(
      value: action is SecondRootIncreaseAction? previousState.value + 1 
        : action is SecondRootDecreaseAction? previousState.value - 1 
        : previousState.value
    );
  });