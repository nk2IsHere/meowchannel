
import 'dart:isolate';

import 'package:meowchannel/extensions/isolate_worker/isolate_wrapper.dart';

/// [IsolateWrapper] for [IsolateManagerImpl]
/// Maintain a real [Isolate].
class IsolateWrapperImpl extends IsolateWrapper {
  IsolateWrapperImpl(this.isolate);

  final Isolate isolate;

  @override
  void kill() {
    isolate.kill();
  }
}
