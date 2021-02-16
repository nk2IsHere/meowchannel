import 'package:meowchannel/core/dispatcher.dart';
import 'package:meowchannel/core/state_action.dart';
import 'package:meowchannel/extensions/channel.dart';

class Module<S> {

  final String _id;
  final Dispatcher Function(
    Dispatcher dispatcher,
    void Function(dynamic Function(S)) initializer,
    StateChannel<StateAction<S, dynamic>> state,
    Dispatcher next
  ) _closure;

  Module(this._id, this._closure);


  String get id => _id;

  Dispatcher call(
    Dispatcher dispatcher,
    void Function(dynamic Function(S)) initializer,
    StateChannel<StateAction<S, dynamic>> state,
    Dispatcher next
  ) => _closure(dispatcher, initializer, state, next);
}