import 'dart:async';

import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

import 'log_recorder.dart';

class Log {
  static final _log = Logger('logger_plus');

  static bool forceStackTrace = false;

  static StackTrace? get _stackTrace =>
      forceStackTrace ? Trace.current(2) : null;

  static void v(Object? message, [StackTrace? stackTrace]) {
    _log.finest(message, null, stackTrace ?? _stackTrace);
  }

  static void d(Object? message, [StackTrace? stackTrace]) {
    _log.finer(message, null, stackTrace ?? _stackTrace);
  }

  static void ok(Object? message, [StackTrace? stackTrace]) {
    _log.fine(message, null, stackTrace ?? _stackTrace);
  }

  static void config(Object? message, [StackTrace? stackTrace]) {
    _log.config(message, null, stackTrace ?? _stackTrace);
  }

  static void i(Object? message, [StackTrace? stackTrace]) {
    _log.info(message, null, stackTrace ?? _stackTrace);
  }

  static void w(Object? message, [StackTrace? stackTrace]) {
    _log.warning(message, null, stackTrace ?? _stackTrace);
  }

  static void e(Object? message, [StackTrace? stackTrace]) {
    _log.severe(message, null, stackTrace ?? Trace.current(1));
  }

  static void wtf(Object? message, [StackTrace? stackTrace]) {
    _log.shout(message, null, stackTrace ?? Trace.current(1));
  }

  static StreamSubscription<LogRecord> listen(LogRecorder recorder) {
    forceStackTrace |= recorder.forceStackTrace;
    return _log.onRecord.listen(recorder);
  }

  static void clearListeners() {
    _log.clearListeners();
  }
}
