import 'package:meowflux/core/dispatcher.dart';

typedef Middleware<S> = Dispatcher Function(
  Dispatcher dispatcher,
  S Function() getState,
  Dispatcher next
);