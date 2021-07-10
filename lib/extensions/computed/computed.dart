
class Computed<S, T> {
  final T Function(S state, T? previousValue) _closure;

  Computed(this._closure);

  T call(S state, T? previousValue) => _closure(state, previousValue);
}
