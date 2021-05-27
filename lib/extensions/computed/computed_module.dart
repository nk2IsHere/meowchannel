
import 'package:meowchannel/extensions/computed/computed.dart';
import 'package:meowchannel/extensions/computed/computed_actions.dart';
import 'package:meowchannel/core/actions.dart';
import 'package:meowchannel/core/module.dart';

extension _ApplyExtension<T> on T {
   T apply(Function(T) closure) {
     closure(this);
     return this;
   }
}

Module<S> computedModule<S>(
  Map<String, Computed<S, dynamic>> computed
) => Module('computedModule', (dispatcher, initialize, state, next) {
  Map<String, dynamic> storage = Map();
  initialize((state) => computed.map((key, value) => MapEntry(key, value(state, null)))
    ..apply((value) => storage = value));
  final subscription = state.asStream()
    .listen((stateAction) {
      if(stateAction.action is ComputedStorageUpdateAction
          || stateAction.action is MeowChannelInit)
        return;

      dispatcher(ComputedStorageUpdateAction(
        data: computed.map((key, value) => MapEntry(key, value(stateAction.state, storage[key])))
          ..apply((value) => storage = value)
      ));
    });

  return (dynamic action) async {
    if(action is MeowChannelClose) {
      subscription.cancel();
    }

    await next(action);
  };
});
