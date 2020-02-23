import 'package:meowchannel/core/dispatcher.dart';

abstract class AbstractStore<S> extends StoreDispatcher {
  void close();
  void getState();
  Stream<S> channel;
}