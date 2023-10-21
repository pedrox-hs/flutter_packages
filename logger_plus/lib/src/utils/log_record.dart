import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

import '../logger.dart';
import 'level.dart';

extension LogRecordExt on LogRecord {
  bool get isSevere => level >= Level.SEVERE;

  String get emoji => level.emoji;

  bool get hasLocation =>
      trace?.frames.isNotEmpty == true || loggerName != libLoggerName;

  String get location {
    final frame = trace?.frames.firstOrNull;
    if (frame == null) return loggerName != libLoggerName ? loggerName : '';

    return [frame.uri, frame.line, frame.column]
        .takeWhile((value) => value != null)
        .join(':');
  }

  Trace? get trace => stackTrace != null ? Trace.from(stackTrace!) : null;
}

extension IterableExt<T> on Iterable<T> {
  T? get firstOrNull => isNotEmpty ? first : null;
}
