import 'package:meowchannel/meowchannel.dart';

typedef StoreHook<S> = Function(
  Store<S>,
  S
);