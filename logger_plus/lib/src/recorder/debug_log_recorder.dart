import 'dart:io';

import 'package:logging/logging.dart';

import '../log_recorder.dart';
import '../utils/color.dart';
import '../utils/level.dart';
import '../utils/log_record.dart';

/// A [LogRecorder] that prints beautiful logs to the console.
/// It also prints the stack trace for [Level.SEVERE] logs.
class DebugLogRecorder extends LogRecorder with LogRecorderTemplateMixin {
  @override
  final bool forceStackTrace = true;

  @override
  final String template =
      '{emoji} {message} {padding} {location}\n{error}\n{stackTrace}';

  @override
  String? resolveRecordValue(
    LogRecord record,
    String key,
    List<String> params,
  ) {
    final color = record.level.color;

    switch (key) {
      case 'emoji':
        return record.emoji;
      case 'message':
        return record.message.colored(color);
      case 'padding':
        return _applyPadding(record).colored(color.light.normal);
      case 'location':
        return record.location.colored(color.light.normal);
      case 'error':
        return record.isSevere && record.error != null
            ? record.error?.toStringColored(color.light.normal)
            : '';
      case 'stackTrace':
        return record.isSevere
            ? record.trace!.toStringColored(color.light.normal)
            : '';
      default:
        return null;
    }
  }

  String _applyPadding(LogRecord record) => stdout.hasTerminal
      ? ''.padRight(
          stdout.terminalColumns -
              record.message.length -
              record.location.length -
              6,
          '-',
        )
      : (record.hasLocation ? 'at' : '');
}
