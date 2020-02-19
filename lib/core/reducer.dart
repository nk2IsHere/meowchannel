import 'package:meowflux/core/action.dart';

typedef Reducer<S> = S Function(Action action, S previousState);
