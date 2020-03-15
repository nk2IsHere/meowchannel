import 'package:meowchannel/core/action.dart';
import 'package:meowchannel/core/reducer.dart';

Reducer<S> typedReducer<A extends Action, S>(
  S Function(A action, S previousState) reducer,
  { S initialState }
) => (Action action, S previousState) {
  return action is A? reducer(action, previousState ?? initialState) 
    : previousState ?? initialState;
};