// ignore: close_sinks

import 'dart:async';

import 'package:meowchannel/extensions/isolate_worker/impl/web_isolate_wrapper_impl.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_events.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_functions.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_manager.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_messenger.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_wrapper.dart';

/// Web [IsolateManager]'s implementation.
/// It doesn't creates [Isolate].
class WebIsolateManagerImpl extends IsolateManager {
  WebIsolateManagerImpl(IsolateWrapper isolate, IsolateMessenger messenger)
      : super(isolate, messenger);

  static Future<WebIsolateManagerImpl> createIsolate(
    IsolateRun run,
    IsolateInitializer initializer
  ) async {
    final fromIsolate = StreamController<Event>.broadcast();
    final toIsolate = StreamController<Event>.broadcast();
    final sendFromIsolate = fromIsolate.add;
    final sendToIsolate = toIsolate.add;
    final toIsolateStream = toIsolate.stream;
    final fromIsolateStream = fromIsolate.stream;

    final isolateMessenger = IsolateMessenger(fromIsolateStream, sendToIsolate);

    // this function run isolated function (IsolateRun)
    run(IsolateMessenger(toIsolateStream, sendFromIsolate), initializer);

    return WebIsolateManagerImpl(
      WebIsolateWrapper(),
      isolateMessenger,
    );
  }
}
