
import 'dart:async';

import 'package:meowchannel/extensions/isolate_worker/isolate_events.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_worker_manager.dart';

class IsolateConnector {

  final void Function(Event) sendEvent;
  final Stream<Event> _eventsStream;
  late StreamSubscription<Event> _eventSubscription;

  IsolateConnector(this.sendEvent, this._eventsStream) {
    _eventSubscription = _eventsStream
        .listen(_listener);
  }

  void _listener(Event event) {
    if (event is IsolateWorkerCreatedEvent) {
      IsolateWorkerManager.instance!.bindFreeWrapper(event.id, event.type);
    } else if(event is IsolateWorkersRegisteredEvent) {
      IsolateWorkerManager.instance!.workersRegistered(event.key, event.workers);
    } else if (event is WorkerOutEvent) {
      IsolateWorkerManager.instance!.workerStateReceiver(event.id!, event);
    }
  }

  void dispose() {
    _eventSubscription.cancel();
  }
}
