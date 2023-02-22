import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:stack_trace/stack_trace.dart';

import 'level.dart';
import 'utils.dart';

// ignore: non_constant_identifier_names
final Log = _RootLogger();

abstract class Logger {
  const Logger();

  @visibleForOverriding
  void print(Level level, dynamic message, StackTrace? stackTrace);

  void d(dynamic message) {
    print(Level.debug, message, null);
  }

  void i(dynamic message) {
    print(Level.info, message, null);
  }

  void wtf(dynamic message) {
    print(Level.wtf, message, null);
  }

  void w(dynamic message) {
    print(Level.warn, message, null);
  }

  void e(dynamic message, [StackTrace? stackTrace]) {
    print(Level.error, message, stackTrace);
  }

  void f(dynamic message, [StackTrace? stackTrace]) {
    print(Level.fatal, message, stackTrace);
  }
}

class _RootLogger extends Logger {
  Tree? _tree = kDebugMode ? const DebugTree() : null;

  void plant(Tree? tree) {
    _tree = tree;
  }

  Logger tag(String tag) => _tree?.copyWith(tag) ?? this;

  @override
  void print(Level level, message, StackTrace? stackTrace) {
    _tree?.print(level, message, stackTrace);
  }
}

@immutable
abstract class Tree extends Logger {
  const Tree([this.explicitTag]);

  final String? explicitTag;

  String get tag => explicitTag ?? tagFromCaller();

  @override
  void print(Level level, message, StackTrace? stackTrace) {
    log(level, tag, message, stackTrace);
  }

  @visibleForOverriding
  void log(Level level, String tag, dynamic message, StackTrace? stackTrace);

  Tree copyWith(String tag);
}

class DebugTree extends Tree {
  const DebugTree([String? tag]) : super(tag);

  @override
  void log(Level level, String tag, dynamic message, StackTrace? stackTrace) {
    final stackText = stackTrace != null ? '\n${stackTrace.toString()}' : '';
    tag = level.decorate(tag, colorize: !Platform.isIOS);

    debugPrint('$tag: ${message.toString()}$stackText');
  }

  @override
  Tree copyWith(String tag) => DebugTree(tag);
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
