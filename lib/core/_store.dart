import 'package:meowchannel/core/dispatcher.dart';

abstract class AbstractStore<S> extends StoreDispatcher {
  void close();
  Future<S> getState();
  S getPreviousStateUnsafe();
  S getStateUnsafe();
  Stream<S> channel;
}