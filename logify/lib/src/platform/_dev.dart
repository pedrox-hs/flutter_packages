import 'dart:async';
import 'dart:developer' as dev show log;

import 'stdio.dart';

typedef DevLog =
    void Function(
      String message, {
      DateTime? time,
      int? sequenceNumber,
      int level,
      String name,
      Zone? zone,
      Object? error,
      StackTrace? stackTrace,
    });

/// A stdout that prints to the console.
/// It uses the `dart:developer` library.
class DevStdout implements Stdout {
  const DevStdout([this.log = dev.log]);

  final DevLog log;

  @override
  final bool hasTerminal = false;

  @override
  final bool supportsAnsiEscapes = true;

  @override
  int get terminalColumns =>
      throw const StdoutException('terminalColumns is not supported');

  @override
  void writeln(String message) => log(message);
}
