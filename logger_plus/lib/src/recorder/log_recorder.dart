import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:stack_trace/stack_trace.dart';

abstract class LogRecorder {
  bool get forceStackTrace => false;

  void record(LogRecord record);

  @protected
  Trace? getStackTrace(Object? error, StackTrace? stackTrace) {
    if (error is StackTrace) {
      return Trace.from(error);
    }
    if (stackTrace != null) {
      return Trace.from(stackTrace);
    }
    return null;
  }
}