// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_context.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

abstract class _$WorkerContext<S> {
  const _$WorkerContext();

  void Function(Action) get dispatcher;
  S Function() get state;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! WorkerContext) return false;

    return true &&
        this.dispatcher == other.dispatcher &&
        this.state == other.state;
  }

  int get hashCode {
    return mapPropsToHashCode([dispatcher, state]);
  }

  String toString() {
    return 'WorkerContext <\'dispatcher\': ${this.dispatcher},\'state\': ${this.state},>';
  }

  WorkerContext copyWith(
      {void Function(Action) dispatcher, S Function() state}) {
    return WorkerContext<S>(
      dispatcher: dispatcher ?? this.dispatcher,
      state: state ?? this.state,
    );
  }
}
