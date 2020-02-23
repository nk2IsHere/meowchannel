import 'package:meowchannel/meowchannel.dart';

import 'values_actions.dart';
import 'values_state.dart';

final Reducer<ValuesState> ValuesReducer =
  TypedReducer<ValuesAction, ValuesState>((ValuesAction action, ValuesState previousState) {
    //Does nothing
    return previousState;
  });