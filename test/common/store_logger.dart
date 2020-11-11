import 'package:meowchannel/meowchannel.dart';

final Middleware storeLogger = (dispatcher, state, next) {
  return (dynamic action) async {
    print('STORE ${state()} <- $action');
    return await next(action);
  };
};