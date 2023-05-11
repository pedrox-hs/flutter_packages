// example/main.dart
import 'package:logger_plus/logger_plus.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL;
  Log.addRecorder(ConsoleLogRecorder());
  Log.addRecorder(DebugLogRecorder());

  Log.v('verbose message');
  Log.d('debug message');
  Log.ok('ok message');
  Log.config('config message');
  Log.i('info message');
  Log.w('warn message');
  Log.e('error message');
  Log.wtf('fatal error message');
}
