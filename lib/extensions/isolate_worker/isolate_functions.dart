
import 'package:meowchannel/extensions/isolate_worker/isolate_manager.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_worker.dart';

/// Signature for initialization function which would be run in [Isolate] to
/// initialize your things and provide them to the contexts of workers.
/// Initializer must be a global or static function.
typedef IsolateInitializer<T> = Future<List<dynamic>> Function<T>([T? args]);

typedef IsolateManagerCreator<T> = Future<IsolateManager> Function<T>(
  IsolateRun<T>,
  IsolateInitializer<T>,
  [T? args]
);

typedef IsolateWorkersCreator<A, S> = List<IsolateWorker> Function();

typedef IsolateWorkerKiller = void Function(String id);
