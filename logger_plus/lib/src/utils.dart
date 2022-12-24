

import 'package:stack_trace/stack_trace.dart';

import 'logger.dart';

typedef OnError<T> = T Function(Object exception, StackTrace? stack);

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

String tagFromCaller() {
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