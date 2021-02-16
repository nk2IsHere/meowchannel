
class StateAction<S, A> {
  final S state;
  final A action;

  StateAction(this.state, this.action);

  @override
  String toString() {
    return 'StateAction{state: $state, action: $action}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateAction &&
          runtimeType == other.runtimeType &&
          state == other.state &&
          action == other.action;

  @override
  int get hashCode => state.hashCode ^ action.hashCode;
}