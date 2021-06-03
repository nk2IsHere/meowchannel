
import 'dart:async';
import 'dart:isolate';

import 'package:meowchannel/extensions/isolate_worker/isolate_connector.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_events.dart';
import 'package:meowchannel/extensions/isolate_worker/isolated_connector.dart';
import 'package:meowchannel/extensions/isolate_worker/isolated_worker_manager.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_functions.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_manager.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_messenger.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_worker.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_worker_wrapper.dart';

class IsolateWorkerManager {
  IsolateWorkerManager._(this._isolateManager, this._isolateConnector);

  static IsolateWorkerManager? instance;

  final IsolateConnector _isolateConnector;
  final IsolateManager _isolateManager;
  final _freeWrappers = <Type, List<IsolateWorkerWrapper>>{};
  final _wrappers = <String, IsolateWorkerWrapper>{};
  final _registrationCompleters = <String, Completer<List<Type>>>{};

  static Future<void> initialize<T>(
    IsolateInitializer<T> initializer,
    IsolateManagerCreator<T> createIsolate,
    [T? args]
  ) async {
    instance?.dispose();

    final isolateManager = await createIsolate(
      _isolatedWorkerRunner,
      initializer,
      args
    );

    instance = IsolateWorkerManager._(
      isolateManager,
      IsolateConnector(
        isolateManager.messenger.add,
        isolateManager.messenger,
      )
    );
  }

  IsolateWorkerWrapper<A, S> createWorker<A, S>(Type isolateWorkerType) {
    final wrapper = IsolateWorkerWrapper<A, S>(
      _isolateConnector.sendEvent,
      (String id) => _isolateConnector.sendEvent(CloseIsolateWorkerEvent(id))
    );
    if (!_freeWrappers.containsKey(isolateWorkerType)) {
      _freeWrappers[isolateWorkerType] = [];
    }
    _freeWrappers[isolateWorkerType]!.add(wrapper);

    print('Created wrapper in ${Isolate.current.debugName}');
    _isolateConnector.sendEvent(CreateIsolateWorkerEvent(isolateWorkerType));
    return wrapper;
  }

  void bindFreeWrapper<A, S>(String id, Type isolateWorkerType) {
    assert(
      _freeWrappers.containsKey(isolateWorkerType) && (_freeWrappers[isolateWorkerType]?.isNotEmpty ?? false),
      'No free worker wrapper for $isolateWorkerType',
    );

    _wrappers[id] = _freeWrappers[isolateWorkerType]!.removeAt(0)
      ..connectToWorker(id);
  }

  Completer<List<Type>> registerWorker(String key, IsolateWorkersCreator creator) {
    _isolateConnector.sendEvent(IsolateWorkersRegisterEvent(key, creator));

    final completer = Completer<List<Type>>();
    _registrationCompleters[key] = completer;
    return completer;
  }

  void workersRegistered(String key, List<Type> workers) {
    _registrationCompleters[key]!.complete(workers);
    _registrationCompleters.remove(key);
  }

  void workerStateReceiver(String id, Event event) {
    _wrappers[id]!.add(event);
  }

  static Future<void> _isolatedWorkerRunner<T>(
    IsolateMessenger messenger,
    IsolateInitializer<T> userInitializer,
    [T? args]
  ) async {
    try {
      final Map<Type, dynamic> dependencies = Map.fromIterable(
        await userInitializer(args),
        key: (dependency) => dependency.runtimeType
      );

      IsolatedWorkerManager.initialize(
        messenger,
        dependencies,
        IsolatedConnector(
          messenger.add,
          messenger,
        )
      );
    } catch (e, stacktrace) {
      print("Error in user's IsolateInitializer function.");
      print('Error message: ${e.toString()}');
      print('Last stacktrace: $stacktrace');
    }

    IsolatedWorkerManager.instance?.initializeCompleted();
  }

  /// Free all resources and kill [Isolate].
  void dispose() {
    _isolateManager.isolate.kill();
    _isolateConnector.dispose();
  }
}
