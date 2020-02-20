import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:meowflux/meowflux.dart';

import '2_watcher/values_actions.dart';
import '2_watcher/values_reducer.dart';
import '2_watcher/values_state.dart';
import '2_watcher/values_ui.dart';
import '2_watcher/values_ui_watcher.dart';
import '2_watcher/values_watcher.dart';
import 'common/store_logger.dart';

import '1_basic_store/root_actions.dart';
import '1_basic_store/root_reducer.dart';
import '1_basic_store/root_state.dart';

void main() {
  test('1. basic counter test', () async {
    final store = Store(
      reducer: rootReducer,
      initialState: RootState(value: 0),
      middleware: [
        storeLogger
      ]
    );

    print('TEST retrieve value');
    final initialState = await store.getState();
    print('TEST value: $initialState');
    expect(initialState.value, 0);

    print('TEST edit value');
    await store.dispatch(RootIncreaseAction());
    await store.dispatch(RootIncreaseAction());
    await store.dispatch(RootDescreaseAction());
    
    print('TEST retrieve value');
    final resultState = await store.getState();
    print('TEST value: $resultState');
    expect(resultState.value, 1);
  });

  test('2. workers and watchers test', () async {
    final ui = ValuesUi();
    final store = Store(
      reducer: valuesReducer,
      initialState: ValuesState(values: []),
      middleware: [
        storeLogger,
        WorkerMiddleware<ValuesState>([
          ValuesUiWatcher(ValuesUiWorker(ui)),
          ValuesWatcher(ValuesWorker)
        ])
      ]
    );

    print('TEST run worker:');
    store.dispatch(ValuesAddValueAction(value: "apple"));
    store.dispatch(ValuesAddValueAction(value: "koala"));
    store.dispatch(ValuesAddValueAction(value: "browney"));
    store.dispatch(ValuesAddValueAction(value: "watch"));

    print('TEST await all workers to finish');
    await Future.delayed(Duration(seconds: 7), () => "");

    print("TEST 'ui' shows this: ${ui.render()}");

    expect(ui.render(), "APPLEKOALABROWNEYWATCH");
  });
}
