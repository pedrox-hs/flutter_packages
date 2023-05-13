import 'package:logging/logging.dart';

import '../log_recorder.dart';
import '../utils/log_record.dart';
import '../utils/string.dart';

class ConsoleLogRecorder extends LogRecorder {
  @override
  String record(LogRecord record) {
    final tag = record.level.name.padBoth(9);
    final message = '[$tag] ${record.message}';

    if (record.level < Level.SEVERE) return message;

    final buffer = StringBuffer(message);

    buffer.writeln(record.error ?? '');
    buffer.write(record.trace ?? '');

    return buffer.toString();
  }
}
