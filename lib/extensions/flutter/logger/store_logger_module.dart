
import 'package:flutter/foundation.dart';
import 'package:meowchannel/core/module.dart';

Module<S> storeLoggerModule<S>(String tag) => Module<S>('storeLoggerModule', (dispatcher, initialize, state, next) {
  return (dynamic action) async {
    if(kDebugMode) print('[$tag] ${state.valueOrNull().state} <- $action');
    return next(action);
  };
});