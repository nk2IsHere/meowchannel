import 'dart:async';
import 'package:meowchannel/core/reducer.dart';

typedef TypedReducer<A, S> = FutureOr<S> Function(A action, S previousState);

Reducer<S> typedReducer<A, S>(
  TypedReducer<A, S> reducer
) => (dynamic action, S previousState) async {
  return action is A?
    await reducer(action, previousState)
    : previousState;
};
