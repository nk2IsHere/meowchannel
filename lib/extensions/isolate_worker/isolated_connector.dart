
import 'package:meowchannel/extensions/isolate_worker/isolate_events.dart';
import 'package:meowchannel/extensions/isolate_worker/isolated_worker_manager.dart';

class IsolatedConnector {

  final void Function(Event) sendEvent;
  final Stream<Event> _eventsStream;

  IsolatedConnector(this.sendEvent, this._eventsStream) {
    _eventsStream.listen(_listener);
  }

  void _listener(Event event) {
    try {
      if (event is CreateIsolateWorkerEvent) {
        IsolatedWorkerManager.instance!.initializeWorker(event.type);
      } else if (event is CloseIsolateWorkerEvent) {
        IsolatedWorkerManager.instance!.closeWorker(event.id);
      } else if (event is IsolateWorkersRegisterEvent) {
        IsolatedWorkerManager.instance!.registerWorker(event.key, event.creator);
      } else if(event is WorkerInEvent && event.id != null) {
        IsolatedWorkerManager.instance!.workerEventReceiver(event.id!, event);
      }
    } catch(e, stacktrace) {
      print("[meowchannel] Error in IsolatedWorkerManager function.");
      print('[meowchannel] Error message: ${e.toString()}');
      print('[meowchannel] Last stacktrace: $stacktrace');
    }
  }
}
