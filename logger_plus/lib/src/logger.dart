import 'dart:async';

import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

import 'log_recorder.dart';

class Log {
  static final _log = Logger('logger_plus');

  static bool forceStackTrace = false;

  static StackTrace? get _stackTrace =>
      forceStackTrace ? Trace.current(2) : null;

  static void v(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log.finest(message, error, stackTrace ?? _stackTrace);
  }

  static void d(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log.finer(message, error, stackTrace ?? _stackTrace);
  }

  static void ok(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log.fine(message, error, stackTrace ?? _stackTrace);
  }

  static void config(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log.config(message, error, stackTrace ?? _stackTrace);
  }

  static void i(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log.info(message, error, stackTrace ?? _stackTrace);
  }

  static void w(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log.warning(message, error, stackTrace ?? _stackTrace);
  }

  static void e(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log.severe(message, error, stackTrace ?? Trace.current(1));
  }

  static void wtf(Object? message, [Object? error, StackTrace? stackTrace]) {
    _log.shout(message, error, stackTrace ?? Trace.current(1));
  }

  static StreamSubscription<LogRecord> listen(LogRecorder recorder) {
    forceStackTrace |= recorder.forceStackTrace;
    return _log.onRecord.listen(recorder);
  }

  static void clearListeners() {
    _log.clearListeners();
  }
}
