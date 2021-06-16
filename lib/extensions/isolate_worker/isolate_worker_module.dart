
import 'package:flutter/foundation.dart';
import 'package:meowchannel/core/actions.dart';
import 'package:meowchannel/core/module.dart';
import 'package:meowchannel/extensions/channel.dart';
import 'package:meowchannel/extensions/isolate_worker/impl/isolate_manager_impl.dart';
import 'package:meowchannel/extensions/isolate_worker/impl/web_isolate_manager_impl.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_events.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_functions.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_initialize_arguments.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_worker_manager.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_worker_wrapper.dart';
import 'package:uuid/uuid.dart';

Future<void> initializeIsolateWorkerModule(
  IsolateInitializer initializer,
  [IsolateInitializeArguments args = const IsolateInitializeArguments({})]
) async {
  await IsolateWorkerManager.initialize(
    initializer,
    kIsWeb? WebIsolateManagerImpl.createIsolate
      : IsolateManagerImpl.createIsolate,
    args
  );
}

Module<S> isolateWorkerModule<A, S>(
    IsolateWorkersCreator workersCreator
) => Module('isolateWorkerModule', (dispatcher, initialize, state, next) {
  final MutableStateChannel<dynamic> channel = StateChannelImpl<dynamic>();

  List<IsolateWorkerWrapper<A, S>>? workerWrappers;
  final unsentStates = <S>[
    state.valueOrNull()?.state as S // initial state
  ];
  final unsentActions = <A>[];

  final registrationKey = Uuid().v4();
  final registrationCompleter = IsolateWorkerManager.instance!.registerWorker(registrationKey, workersCreator);

  registrationCompleter.future
    .then((workers) {
      workerWrappers = workers.map((workerType) => IsolateWorkerManager.instance!.createWorker<A, S>(workerType))
        .toList();

      for(final worker in workerWrappers!) {
        worker.where((event) => event is IsolateWorkerOutActionEvent)
          .cast<IsolateWorkerOutActionEvent>()
          .listen((event) {
            dispatcher(event.action);
          });
      }

      for(final state in unsentStates) {
        for (final worker in workerWrappers!) {
          worker.add(IsolateWorkerStateEvent<S>(null, state));
        }
      }

      for(final action in unsentActions) {
        for (final worker in workerWrappers!) {
          worker.add(IsolateWorkerInActionEvent<A>(null, action));
        }
      }
  });

  state.asStream()
    .listen((state) {
      if(workerWrappers == null) {
        unsentStates.add(state.state);
      } else {
        for (final worker in workerWrappers!) {
          worker.add(IsolateWorkerStateEvent<S>(null, state.state));
        }
      }
    });

  channel.asStream()
    .where((action) => action is A)
    .cast<A>()
    .listen((action) {
      if(workerWrappers == null) {
        unsentActions.add(action);
      } else {
        for(final worker in workerWrappers!) {
          worker.add(IsolateWorkerInActionEvent<A>(null, action));
        }
      }
    });

  return (dynamic action) async {

    if(action is MeowChannelClose) {
      channel.close();
    } else {
      channel.send(action);
    }

    await next(action);
  };
});
