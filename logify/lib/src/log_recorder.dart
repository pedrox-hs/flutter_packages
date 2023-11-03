import 'package:logging/logging.dart';

import 'platform/io.dart' as io;
import 'platform/stdio.dart';
import 'utils/string.dart';

abstract class LogRecorder {
  LogRecorder({
    Stdout? stdout,
    Stdout? stderr,
  })  : stdout = stdout ?? io.stdout, // coverage:ignore-line
        stderr = stderr ?? io.stderr; // coverage:ignore-line

  final Stdout stdout;
  final Stdout stderr;

  String record(LogRecord record);

  void call(LogRecord record) {
    final message = this.record(record);
    if (record.level >= Level.SEVERE) {
      stderr.writeln(message);
    } else {
      stdout.writeln(message);
    }
  }
}

mixin LogRecorderTemplateMixin on LogRecorder {
  String get template;

  String? resolveRecordValue(
    LogRecord record,
    String key,
    List<String> params,
  );

  @override
  String record(LogRecord record) => template
      .split('\n')
      .map(
        (line) => line.formatWithParameterized(
          (key, params) => resolveRecordValue(record, key, params),
        ),
      )
      .where((line) => line.isNotEmpty)
      .join('\n');
}
