import 'package:meowchannel/core/action.dart';

typedef Reducer<S> = S Function(Action action, S previousState);
