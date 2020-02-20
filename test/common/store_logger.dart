import 'package:meowflux/meowflux.dart';

final Middleware storeLogger = (dispatcher, state, next) {
  return (Action action) {
    print('STORE ${state()} <- $action');
    return next(action);
  };
};