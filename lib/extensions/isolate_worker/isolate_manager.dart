
import 'package:meowchannel/extensions/isolate_worker/isolate_functions.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_messenger.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_wrapper.dart';

/// Signature for function which will run in isolate
typedef IsolateRun<T> = void Function<T>(
  IsolateMessenger messager,
  IsolateInitializer<T> initializer,
  [T? args]
);

/// Abstract class for [IsolateManagerImpl] which implement work with real [Isolate],
/// [MockIsolateManager] which doesn't create a real [Isolate] and web implementation
abstract class IsolateManager {
  IsolateManager(this.isolate, this.messenger);

  final IsolateWrapper isolate;
  final IsolateMessenger messenger;
}
