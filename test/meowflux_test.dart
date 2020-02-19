import 'package:flutter_test/flutter_test.dart';

import 'package:meowflux/meowflux.dart';

import 'common/store_logger.dart';

import '1_basic_store/root_actions.dart';
import '1_basic_store/root_reducer.dart';
import '1_basic_store/root_state.dart';

void main() {
  test('1. basic counter test', () async {
    final store = BaseStore(
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
    print('TESTe value: $resultState');
    expect(resultState.value, 1);
  });
}
