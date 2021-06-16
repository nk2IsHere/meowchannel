
import 'dart:async';
import 'dart:isolate';

import 'package:meowchannel/extensions/isolate_worker/impl/isolate_wrapper_impl.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_events.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_functions.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_binding.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_initialize_arguments.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_manager.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_messenger.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_wrapper.dart';

/// Create and initialize [Isolate] and [IsolateMessenger].
class IsolateManagerImpl extends IsolateManager {
  IsolateManagerImpl(IsolateWrapper isolate, IsolateMessenger messenger)
      : super(isolate, messenger);

  /// Create Isolate, initialize messages and run your function
  /// with [IsolateMessenger] and user's [IsolateInitializer] func
  static Future<IsolateManagerImpl> createIsolate(
    IsolateRun run,
    IsolateInitializer initializer,
    IsolateInitializeArguments args,
  ) async {
    assert(
      '$initializer'.contains(' static'),
      'Initialize function must be a static or global function',
    );

    final fromIsolate = ReceivePort();
    final toIsolateCompleter = Completer<SendPort>();
    final isolate = await Isolate.spawn<_IsolateSetup>(
      _runInIsolate,
      _IsolateSetup(
        fromIsolate.sendPort,
        run,
        initializer,
        args
      ),
      errorsAreFatal: false,
    );

    final fromIsolateStream = fromIsolate.asBroadcastStream();
    final subscription = fromIsolateStream.listen((message) {
      if (message is SendPort) {
        toIsolateCompleter.complete(message);
      }
    });
    final toIsolate = await toIsolateCompleter.future;
    await subscription.cancel();

    final isolateMessenger = IsolateMessenger(
      fromIsolateStream.where((event) => event is Event)
          .cast<Event>(),
      toIsolate.send
    );

    return IsolateManagerImpl(
      IsolateWrapperImpl(isolate),
      isolateMessenger,
    );
  }

  static Future<void> _runInIsolate(_IsolateSetup setup) async {
    final toIsolate = ReceivePort();
    final toIsolateStream = toIsolate.asBroadcastStream();
    setup.fromIsolate.send(toIsolate.sendPort);
    final isolateMessenger = IsolateMessenger(
      toIsolateStream.where((event) => event is Event)
          .cast<Event>(),
      setup.fromIsolate.send,
    );

    // Initialize platform channel in isolate
    IsolateBinding();
    setup.task(isolateMessenger, setup.userInitializer, setup.args);
  }
}

class _IsolateSetup {
  final SendPort fromIsolate;
  final IsolateInitializer userInitializer;
  final IsolateRun task;
  final IsolateInitializeArguments args;

  _IsolateSetup(
    this.fromIsolate,
    this.task,
    this.userInitializer,
    this.args
  );
}
