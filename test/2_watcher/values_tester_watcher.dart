import 'package:meowchannel/meowchannel.dart';

import 'values_actions.dart';
import 'values_state.dart';
import 'values_tester.dart';

//
//  Since in flutter it is not allowed to explicitly say "RUN IN UI THREAD"
//  be sure to double-check that Workers/Middlewares interacting with Ui are only showing data, not tampering with it.
//
//  The most intended way to update ui is by using store 'channel' property
//
Worker<ValuesTesterAction, ValuesState> ValuesTesterWorker(
  ValuesTester ui
) => 
  worker((context, action) async {
    if(action is ValuesTesterAddValueAction)
      //Show the results
      ui.showValue(action.value);
  });

Watcher<ValuesTesterAction, ValuesState> ValuesTesterWatcher(
  Worker<ValuesTesterAction, ValuesState> worker
) =>
  watcher(worker, (actionStream, context) {
    return actionStream.where((action) => action is ValuesTesterAction)
      .cast<ValuesTesterAction>();
  });