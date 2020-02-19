import 'package:meowflux/core/reducer.dart';
import 'package:meowflux/meowflux.dart';

import 'values_actions.dart';
import 'values_state.dart';

final Reducer<ValuesState> valuesReducer =
  TypedReducer<ValuesAction, ValuesState>(ValuesState(values: []), (ValuesAction action, ValuesState previousState) {
    //Does nothing
    return previousState;
  });