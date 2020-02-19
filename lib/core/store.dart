import 'package:meowflux/core/dispatcher.dart';

abstract class Store<S> extends StoreDispatcher {
  Future<S> getState();
  Stream<S> stateStream;
}