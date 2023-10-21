import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

import '../logger.dart';
import 'level.dart';

extension LogRecordExt on LogRecord {
  bool get isSevere => level >= Level.SEVERE;

  String get emoji => level.emoji;

  String? get location {
    final frame = trace?.frames.firstOrNull;
    // make sure to not return the location for the logify package
    if (frame == null) return loggerName != libLoggerName ? loggerName : null;

    return [frame.uri, frame.line, frame.column]
        .takeWhile((value) => value != null)
        .join(':');
  }

  Object? get errorIfSevere => isSevere ? error : null;

  Trace? get trace => stackTrace != null ? Trace.from(stackTrace!) : null;

  Trace? get traceIfSevere => isSevere ? trace : null;
}

extension IterableExt<T> on Iterable<T> {
  T? get firstOrNull => isNotEmpty ? first : null;
}