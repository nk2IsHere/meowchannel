import 'package:meowchannel/core/reducer.dart';

Reducer<S> typedReducer<A, S>(
  Future<S> Function(A action, S previousState) reducer,
  { Future<S> initialState }
) => (dynamic action, S previousState) async {
  return action is A? reducer(action, previousState ?? initialState)
    : previousState ?? initialState;
};