import 'package:meowchannel/core/action.dart';

typedef Reducer<S> = Future<S> Function(Action action, S previousState);
