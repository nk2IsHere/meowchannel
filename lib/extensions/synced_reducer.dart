import 'package:meowchannel/core/action.dart';
import 'package:meowchannel/core/reducer.dart';

typedef SyncedReducer<S> = S Function(Action action, S previousState);

Reducer<S> syncedReducer<A extends Action, S>(
  S Function(A action, S previousState) reducer,
  { S initialState }
) => (Action action, S previousState) async {
  return reducer(action, previousState);
};