import 'package:meowchannel/core/action.dart';

abstract class StoreDispatcher {
  void dispatch(Action action); 
}

typedef Dispatcher = void Function(Action action);