import 'package:meowchannel/core/action.dart';
import 'package:meowchannel/core/reducer.dart';

Reducer<S> combinedReducer<S>(
  Iterable<Reducer<S>> reducers
) => (Action action, S previousState) {
  return reducers.fold<S>(
    previousState, 
    (previousState, reducer) => reducer(action, previousState)
  );
};