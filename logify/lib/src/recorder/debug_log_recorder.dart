import 'package:logging/logging.dart';

import '../log_recorder.dart';
import '../platform/stdio.dart';
import '../utils/color.dart';
import '../utils/level.dart';
import '../utils/log_record.dart';

/// A [LogRecorder] that prints beautiful logs to the console.
/// It also prints the stack trace for [Level.SEVERE] logs.
class DebugLogRecorder extends LogRecorder with LogRecorderTemplateMixin {
  DebugLogRecorder({super.stdout, super.stderr});

  @override
  final String template = '{emoji} {message} {location}\n{error}\n{stackTrace}';

  @override
  String? resolveRecordValue(
    LogRecord record,
    String key,
    List<String> params,
  ) {
    final stdout = record.isSevere ? stderr : this.stdout;
    final color =
        stdout.supportsAnsiEscapes
            ? record.level.color
            : const ConsoleColor.none();

    switch (key) {
      case 'emoji':
        return record.level.emoji;
      case 'message':
        return record.message.colored(color);
      case 'location':
        // maybe make this configurable from [params]?
        final location = record.location;
        if (location == null) return '';
        return _applyPadding(
          stdout,
          record.message,
          location,
        ).colored(color.light.normal);
      case 'error':
        return record.errorIfSevere?.colored(color.light.normal) ?? '';
      case 'stackTrace':
        return record.traceIfSevere?.colored(color.light.normal) ?? '';
      default:
        return null;
    }
  }

  String _applyPadding(Stdout stdout, String message, String location) {
    if (!stdout.hasTerminal) return 'at $location';
    final size =
        stdout.terminalColumns - message.length - 4; // 4 = emoji + spaces + 1

    return ' $location'.padLeft(size, '-');
  }
}

extension _ObjectColoredExt on Object {
  String colored(ConsoleColor color) => color.wrap(toString());
}
