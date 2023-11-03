import 'dart:async';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:stack_trace/stack_trace.dart';

import 'log_recorder.dart';

const libLoggerName = 'logify';

const _defaultErrorMessage =
    'An error occurred, but no error message was provided.';

const _defaultWtfMessage =
    'A Terrible Failure occurred, but no error message was provided.';

@visibleForTesting
Logger defaultLogger = Logger(libLoggerName);

class Log {
  static Logger get logger => defaultLogger;

  static StackTrace get _requiredStackTrace => Trace.current(2);

  static StackTrace? get _optionalStackTrace {
    Trace? trace;

    // enable stacktrace on non error logs only in debug mode
    assert(() {
      trace = Trace.current(3);
      return true;
    }());

    return trace;
  }

  static void v(Object? message, [Object? error, StackTrace? stackTrace]) {
    logger.finest(message, error, stackTrace ?? _optionalStackTrace);
  }

  static void d(Object? message, [Object? error, StackTrace? stackTrace]) {
    logger.finer(message, error, stackTrace ?? _optionalStackTrace);
  }

  static void ok(Object? message, [Object? error, StackTrace? stackTrace]) {
    logger.fine(message, error, stackTrace ?? _optionalStackTrace);
  }

  static void config(Object? message, [Object? error, StackTrace? stackTrace]) {
    logger.config(message, error, stackTrace ?? _optionalStackTrace);
  }

  static void i(Object? message, [Object? error, StackTrace? stackTrace]) {
    logger.info(message, error, stackTrace ?? _optionalStackTrace);
  }

  static void w(Object? message, [Object? error, StackTrace? stackTrace]) {
    logger.warning(message, error, stackTrace ?? _optionalStackTrace);
  }

  static void e(Object? message, [Object? error, StackTrace? stackTrace]) {
    logger.severe(
      message,
      error ?? message ?? _defaultErrorMessage,
      stackTrace ?? _requiredStackTrace,
    );
  }

  static void wtf(Object? message, [Object? error, StackTrace? stackTrace]) {
    logger.shout(
      message,
      error ?? message ?? _defaultWtfMessage,
      stackTrace ?? _requiredStackTrace,
    );
  }

  static StreamSubscription<LogRecord> listen(LogRecorder recorder) =>
      logger.onRecord.listen(recorder.call);

  static void clearListeners() => logger.clearListeners();
}
