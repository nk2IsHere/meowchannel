import 'package:meowchannel/core/reducer.dart';

typedef SyncedReducer<S> = S Function(dynamic action, S previousState);

Reducer<S> syncedReducer<A, S>(
  S Function(A action, S previousState) reducer,
  { S initialState }
) => (dynamic action, S previousState) async {
  return reducer(action, previousState);
};