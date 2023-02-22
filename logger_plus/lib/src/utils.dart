

import 'package:stack_trace/stack_trace.dart';

typedef OnError<T> = T Function(Object exception, StackTrace? stack);

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