import 'package:meowflux/meowflux.dart';

import 'values_actions.dart';
import 'values_state.dart';
import 'values_ui.dart';

//
//  Since in flutter it is not allowed to explicitly say "RUN IN UI THREAD"
//  be sure to double-check that Workers/Middlewares interacting with Ui are only showing data, not tampering with it
//
Worker<ValuesUiAction, ValuesState> ValuesUiWorker(
  //BuildContext..
  ValuesUi ui
) => 
  worker((context, action) async {
    if(action is ValuesUiAddValueAction)
      //Show the results
      ui.showValue(action.value);
  });

Watcher<ValuesUiAction, ValuesState> ValuesUiWatcher(
  Worker<ValuesUiAction, ValuesState> worker
) =>
  watcher(worker, (actionStream, context) {
    return actionStream.where((action) => action is ValuesUiAction)
      .cast<ValuesUiAction>();
  });