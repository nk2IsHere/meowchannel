import 'package:meowflux/core/action.dart';

abstract class StoreDispatcher {
  Future dispatch(Action action); 
}

typedef Dispatcher = void Function(Action action);