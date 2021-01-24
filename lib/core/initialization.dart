
import 'package:worker_manager/worker_manager.dart';

Future<void> initializeMeowChannel() async {
  await Executor().warmUp();
}