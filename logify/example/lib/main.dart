// example/main.dart
import 'package:logify/logify.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL;

  printLogs(DebugLogRecorder());
  printLogs(ConsoleLogRecorder());
}

void printLogs(LogRecorder recorder) {
  Log.clearListeners();
  Log.listen(recorder);

  Log.v('Log.v message');
  Log.d('Log.d message');
  Log.ok('Log.ok message');
  Log.config('Log.config message');
  Log.i('Log.i message');
  Log.w('Log.w message');
  Log.e('Log.e message');
  Log.wtf('Log.wtf message');
}
