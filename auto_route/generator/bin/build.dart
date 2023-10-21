import 'package:build_runner/src/entrypoint/build.dart';
import 'package:logging/logging.dart';
import 'package:logify/logify.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Log.listen(DebugLogRecorder());
  // TODO: make it work
  await BuildCommand().run();
}
