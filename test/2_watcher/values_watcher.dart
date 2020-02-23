import 'package:meowchannel/meowchannel.dart';

import 'values_actions.dart';
import 'values_state.dart';

final Worker<ValuesAction, ValuesState> valuesWorker = 
  worker((context, action) async {
    //Workload
    await Future.delayed(Duration(seconds: 1), () => "");
    if(action is ValuesAddValueAction)
      context.put(ValuesTesterAddValueAction(value: action.value.toUpperCase()));
  });

Watcher<ValuesAction, ValuesState> valuesWatcher(
  Worker<ValuesAction, ValuesState> worker
) =>
  watcher(worker, (actionStream, context) {
    return actionStream.where((action) => action is ValuesAction)
      .cast<ValuesAction>();
  });