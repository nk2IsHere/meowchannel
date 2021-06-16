
import 'package:meowchannel/extensions/isolate_worker/isolate_initialize_arguments.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_manager.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_worker.dart';

/// Signature for initialization function which would be run in [Isolate] to
/// initialize your things and provide them to the contexts of workers.
/// Initializer must be a global or static function.
typedef IsolateInitializer = Future<List<dynamic>> Function(IsolateInitializeArguments);

typedef IsolateManagerCreator = Future<IsolateManager> Function(
  IsolateRun,
  IsolateInitializer,
  IsolateInitializeArguments
);

typedef IsolateWorkersCreator<A, S> = List<IsolateWorker> Function();

typedef IsolateWorkerKiller = void Function(String id);
