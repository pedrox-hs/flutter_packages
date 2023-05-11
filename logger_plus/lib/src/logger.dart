import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

import 'recorder/log_recorder.dart';

class Log {
  static final _log = Logger.detached('logger_plus');

  static bool forceStackTrace = false;

  static StackTrace? get _stackTrace =>
      forceStackTrace ? Trace.current(2) : null;

  static void v(Object? message, [StackTrace? stackTrace]) {
    _log.finest(message, stackTrace ?? _stackTrace);
  }

  static void d(Object? message, [StackTrace? stackTrace]) {
    _log.finer(message, stackTrace ?? _stackTrace);
  }

  static void ok(Object? message, [StackTrace? stackTrace]) {
    _log.fine(message, stackTrace ?? _stackTrace);
  }

  static void config(Object? message, [StackTrace? stackTrace]) {
    _log.config(message, stackTrace ?? _stackTrace);
  }

  static void i(Object? message, [StackTrace? stackTrace]) {
    _log.info(message, stackTrace ?? _stackTrace);
  }

  static void w(Object? message, [StackTrace? stackTrace]) {
    _log.warning(message, stackTrace ?? _stackTrace);
  }

  static void e(Object? message, [StackTrace? stackTrace]) {
    _log.severe(message, stackTrace ?? Trace.current(1));
  }

  static void wtf(Object? message, [StackTrace? stackTrace]) {
    _log.shout(message, stackTrace ?? Trace.current(1));
  }

  static void addRecorder(LogRecorder recorder) {
    forceStackTrace = forceStackTrace || recorder.forceStackTrace;
    _log.onRecord.listen(recorder.record);
  }
}
