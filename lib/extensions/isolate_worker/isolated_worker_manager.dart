
import 'dart:async';
import 'dart:isolate';

import 'package:meowchannel/extensions/isolate_worker/isolate_events.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_functions.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_messenger.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_worker.dart';
import 'package:meowchannel/extensions/isolate_worker/isolated_connector.dart';

class IsolatedWorkerManager {
  static IsolatedWorkerManager? instance;

  late IsolateMessenger _messenger;
  late Map<Type, dynamic> dependencies;
  final IsolatedConnector _isolatedConnector;
  final _initializeCompleter = Completer();

  final _freeWorkers = <Type, IsolateWorker>{};
  final _createdWorkers = <String, IsolateWorker>{};

  IsolatedWorkerManager._(
    this._messenger,
    this.dependencies,
    this._isolatedConnector
  );

  static IsolatedWorkerManager initialize(
    IsolateMessenger messenger,
    Map<Type, dynamic> dependencies,
    IsolatedConnector isolatedConnector
  ) {
    return IsolatedWorkerManager.instance = IsolatedWorkerManager._(
      messenger,
      dependencies,
      isolatedConnector
    );
  }

  IsolateWorker _getFreeWorkerByType(Type type) {
    IsolateWorker worker = _freeWorkers.remove(type)!;

    _createdWorkers[worker.id] = worker;
    return worker;
  }

  void workerEventReceiver(String id, Event event) {
    _createdWorkers[id]?.add(event);
  }

  void initializeWorker<A, S>(Type isolateWorkerType) {
    assert(
      _freeWorkers.containsKey(isolateWorkerType),
      'You must register worker or worker wrapper to create it.',
    );
    print('[meowchannel] Initialized worker in ${Isolate.current.debugName}');

    // ignore: close_sinks
    final worker = _getFreeWorkerByType(isolateWorkerType);
    worker
      .where((event) => event is WorkerOutEvent)
      .listen((event) => _isolatedConnector.sendEvent(event));
    _isolatedConnector.sendEvent(IsolateWorkerCreatedEvent(worker.id, worker.runtimeType));
  }

  void closeWorker(String id) {
    assert(
      _createdWorkers.containsKey(id),
      'You are trying to remove worker with with a nonexistent id($id).\n'
          'This can happen if you call close() twice.',
    );
    _createdWorkers.remove(id)?.close();
  }

  void initializeCompleted() {
    _initializeCompleter.complete();
  }

  void registerWorker(String key, IsolateWorkersCreator creator) {
    final workers = creator();
    final workerRegisteredTypes = <Type>[];

    for(final worker in workers) {
      _freeWorkers[worker.runtimeType] = worker;
      workerRegisteredTypes.add(worker.runtimeType);
    }

    _isolatedConnector.sendEvent(IsolateWorkersRegisteredEvent(key, workerRegisteredTypes));
  }

}
