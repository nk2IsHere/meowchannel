import 'package:meowchannel/core/action.dart';
import 'package:meowchannel/core/reducer.dart';

Reducer<S> typedReducer<A extends Action, S>(
  Future<S> Function(A action, S previousState) reducer,
  { Future<S> initialState }
) => (Action action, S previousState) async {
  return action is A? reducer(action, previousState ?? initialState) 
    : previousState ?? initialState;
};