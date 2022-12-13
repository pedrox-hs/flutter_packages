import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart';

import 'level.dart';

abstract class Tree {
  String get tag {
    final trace = Trace.current(1);
    final caller = trace.frames.first;

    String location = trace.frames
        .firstWhere(
          (el) => el.library != caller.library,
          orElse: () => caller,
        )
        .location;

    return location;
  }

  void log(Level level, String tag, dynamic message, [StackTrace? stackTrace]);
}

class DebugTree extends Tree {
  @override
  void log(Level level, String tag, dynamic message, [StackTrace? stackTrace]) {
    final stackText = stackTrace != null ? '\n${stackTrace.toString()}' : '';
    tag = level.decorate(tag, colorize: !Platform.isIOS);

    debugPrint('$tag: ${message.toString()}$stackText');
  }
}
