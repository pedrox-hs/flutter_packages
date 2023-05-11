import 'dart:io';

import 'package:logging/logging.dart';

import '../utils.dart';
import 'log_recorder.dart';

class ConsoleLogRecorder extends LogRecorder {
  @override
  void record(LogRecord record) {
    final tag = record.level.name.padBoth(9);
    final message = '[$tag] ${record.message}\n';

    if (record.level >= Level.SEVERE) {
      final buffer = StringBuffer(message);

      final stackTrace = getStackTrace(record.error, record.stackTrace);
      if (record.error != null && record.error is! StackTrace) {
        buffer.writeln(record.error);
      }

      if (stackTrace != null) buffer.writeln(stackTrace.vmTrace.toString());

      stderr.write(buffer);
    } else {
      stdout.write(message);
    }
  }
}
