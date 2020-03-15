import 'package:meowchannel/core/action.dart';

abstract class CachedAction extends Action {
  final bool skipCache;

  CachedAction({
    this.skipCache = false
  });
}