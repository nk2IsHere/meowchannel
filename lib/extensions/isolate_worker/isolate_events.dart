
import 'package:meowchannel/extensions/isolate_worker/isolate_functions.dart';

abstract class Event {}

class CreateIsolateWorkerEvent extends Event {
  final Type type;

  CreateIsolateWorkerEvent(this.type);
}

class IsolateWorkersRegisterEvent extends Event {
  final String key;
  final IsolateWorkersCreator creator;

  IsolateWorkersRegisterEvent(this.key, this.creator);
}

class IsolateWorkersRegisteredEvent extends Event {
  final String key;
  final List<Type> workers;

  IsolateWorkersRegisteredEvent(this.key, this.workers);
}

class IsolateWorkerCreatedEvent extends Event {
  final String id;
  final Type type;

  IsolateWorkerCreatedEvent(this.id, this.type);
}

class CloseIsolateWorkerEvent extends Event {
  final String id;

  CloseIsolateWorkerEvent(this.id);
}

abstract class WorkerEvent extends Event {
  String? get id;
  WorkerEvent withId(String id);
}

abstract class WorkerInEvent extends WorkerEvent {}

class IsolateWorkerStateEvent<S> extends WorkerInEvent {
  final String? id;
  final S state;

  IsolateWorkerStateEvent(this.id, this.state);

  @override
  WorkerEvent withId(String id) =>
      IsolateWorkerStateEvent<S>(id, this.state);
}

class IsolateWorkerInActionEvent<A> extends WorkerInEvent {
  final String? id;
  final A action;

  IsolateWorkerInActionEvent(this.id, this.action);

  @override
  WorkerEvent withId(String id) =>
      IsolateWorkerInActionEvent<A>(id, this.action);
}

abstract class WorkerOutEvent extends WorkerEvent {}

class IsolateWorkerOutActionEvent extends WorkerOutEvent {
  final String id;
  final dynamic action;

  IsolateWorkerOutActionEvent(this.id, this.action);

  @override
  WorkerEvent withId(String id) =>
      IsolateWorkerOutActionEvent(id, this.action);
}
