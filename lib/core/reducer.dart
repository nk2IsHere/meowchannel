
import 'dart:async';

typedef Reducer<S> = FutureOr<S> Function(dynamic action, S previousState);
