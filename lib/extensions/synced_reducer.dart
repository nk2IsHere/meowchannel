import 'package:meowchannel/core/reducer.dart';

typedef SyncedReducer<A, S> = S Function(A action, S previousState);

Reducer<S> syncedReducer<A, S>(
    SyncedReducer<A, S> reducer,
  { S? initialState }
) => (dynamic action, S previousState) async {
  return reducer(action, previousState);
};
