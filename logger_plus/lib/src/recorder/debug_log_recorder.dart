import 'dart:io';

import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

import '../color.dart';
import '../level.dart';
import '../utils.dart';
import 'log_recorder.dart';

/// A [LogRecorder] that prints beautiful logs to the console.
/// It also prints the stack trace for [Level.SEVERE] logs.
///
/// FIXME: maybe there is a bug with colors in ios devices
/// FIXME: use a better way to get the tag and make it work with to navigation
/// TODO: add support to message templates
class DebugLogRecorder extends LogRecorder {
  @override
  bool get forceStackTrace => true;

  @override
  void record(LogRecord record) {
    var std = stdout;

    final stackTrace = getStackTrace(record.error, record.stackTrace);
    final tag = getTagFromTrace(stackTrace);

    final buffer = StringBuffer(
      '${record.level.emoji} $tag ${record.level.color} ${record.message}\n',
    );

    if (record.level >= Level.SEVERE) {
      std = stderr;
      buffer.write('${record.level.color.light.normal}');
      if (record.error != null && record.error is! StackTrace) {
        buffer.writeln(record.error);
      }
      if (stackTrace != null) buffer.writeln(stackTrace.toString());
    }

    std.write(buffer..write(Color.none));
  }

  String getTagFromTrace(Trace? trace) {
    final frame = trace?.frames.firstOrNull;
    if (frame == null) return '';

    return [' ${frame.uri.normalizePackageUri()}', frame.line, frame.column]
        .takeWhile((value) => value != null)
        .join(':');
  }
}
