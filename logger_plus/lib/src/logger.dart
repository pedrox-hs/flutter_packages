import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart';

import 'level.dart';
import 'tree.dart';

typedef OnError<T> = T Function(Object exception, StackTrace? stack);

abstract class Log {
  static Tree? _tree = kDebugMode ? DebugTree() : null;

  static void plant(Tree? tree) {
    _tree = tree;
  }

  static void d(dynamic message) {
    _log(Level.debug, message);
  }

  static void i(dynamic message) {
    _log(Level.info, message);
  }

  static void wtf(dynamic message) {
    _log(Level.wtf, message);
  }

  static void w(dynamic message) {
    _log(Level.warn, message);
  }

  static void e(dynamic message, [StackTrace? stackTrace]) {
    _log(Level.error, message, stackTrace);
  }

  static void f(dynamic message, [StackTrace? stackTrace]) {
    _log(Level.fatal, message, stackTrace);
  }

  static void _log(Level level, dynamic message, [StackTrace? stackTrace]) {
    _tree?.log(level, _tree?.tag ?? 'LOG', message, stackTrace);
  }
}

OnError get catchErrorLogger {
  Trace currentTrace = Trace.current(1);

  return (Object exception, StackTrace? stackTrace) async {
    final trace = Trace.from(stackTrace ?? Trace.current());
    if (!trace.frames.contains(currentTrace.frames.first)) {
      stackTrace = Trace(trace.frames + currentTrace.frames).vmTrace;
    }
    Log.e(exception, stackTrace);
  };
}
