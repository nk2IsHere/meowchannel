import 'package:meowchannel/core/reducer.dart';

Reducer<S> typedReducer<A, S>(
  Reducer<S> reducer
) => (dynamic action, S previousState) async {
  return action is A?
    await reducer(action, previousState)
    : previousState;
};
