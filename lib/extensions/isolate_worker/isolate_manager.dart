
import 'package:meowchannel/extensions/isolate_worker/isolate_functions.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_initialize_arguments.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_messenger.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_wrapper.dart';

/// Signature for function which will run in isolate
typedef IsolateRun = void Function(
  IsolateMessenger messager,
  IsolateInitializer initializer,
  IsolateInitializeArguments args
);

/// Abstract class for [IsolateManagerImpl] which implement work with real [Isolate],
/// [MockIsolateManager] which doesn't create a real [Isolate] and web implementation
abstract class IsolateManager {
  IsolateManager(this.isolate, this.messenger);

  final IsolateWrapper isolate;
  final IsolateMessenger messenger;
}
