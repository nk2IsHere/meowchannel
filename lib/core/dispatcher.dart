import 'package:meowchannel/core/action.dart';

abstract class StoreDispatcher {
  Future<void> dispatch(Action action); 
}

typedef Dispatcher = Future<void> Function(Action action);