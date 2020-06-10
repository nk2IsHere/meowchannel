import 'package:meowchannel/meowchannel.dart';

final Middleware storeLogger = (dispatcher, state, next) {
  return (Action action) async {
    print('STORE ${state()} <- $action');
    return await next(action);
  };
};