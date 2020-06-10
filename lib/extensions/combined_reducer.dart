import 'package:meowchannel/core/action.dart';
import 'package:meowchannel/core/reducer.dart';

Reducer<S> combinedReducer<S>(
  Iterable<Reducer<S>> reducers
) => (Action action, S previousState) async {
  return reducers.fold<Future<S>>(
    Future.sync(() => previousState), 
    (previousState, reducer) async {
      return reducer(action, await previousState);
    } 
  );
};