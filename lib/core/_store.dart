import 'package:meowflux/core/dispatcher.dart';

abstract class AbstractStore<S> extends StoreDispatcher {
  void close();
  Future<S> getState();
  Stream<S> channel;
}