import 'package:meowchannel/meowchannel.dart';

import 'values_actions.dart';
import 'values_state.dart';

final Reducer<ValuesState> valuesReducer =
  typedReducer<ValuesAction, ValuesState>((ValuesAction action, ValuesState previousState) {
    //Does nothing
    return previousState;
  });