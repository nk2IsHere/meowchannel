import 'package:meowflux/meowflux.dart';


///
/// This is an example of a [Middleware]
/// It is able to change the result of [Dispatcher] result by sending or editing [Action]
///
final Middleware storeLogger = (dispatcher, state, next) {
  return (Action action) {
    print('STORE ${state()} <- $action');
    return next(action);
  };
};