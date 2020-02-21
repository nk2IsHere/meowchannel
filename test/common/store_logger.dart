import 'package:meowchannel/meowchannel.dart';

final Middleware storeLogger = (dispatcher, state, next) {
  return (Action action) {
    print('STORE ${state()} <- $action');
    return next(action);
  };
};