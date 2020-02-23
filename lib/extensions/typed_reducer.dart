import 'package:meowchannel/core/action.dart';
import 'package:meowchannel/core/reducer.dart';

Reducer<S> TypedReducer<A extends Action, S>(
  S Function(A action, S previousState) reducer
) => (Action action, S previousState) {
  return action is A? reducer(action, previousState) 
    : previousState;
};