import 'dart:io' as io show stdout, stderr, Stdout, Platform;

import 'package:meta/meta.dart';

import '../utils/print.dart' show debugPrint;
import 'stdio.dart' show Stdout, StdoutException;

final stdout = PrintStdout(io.stdout);

final stderr = PrintStdout(io.stderr);

/// A stdout that prints to the console.
/// It uses the `debugPrint` implementation.
@visibleForTesting
class PrintStdout implements Stdout {
  const PrintStdout(this.stdout);

  final io.Stdout stdout;

  @override
  bool get hasTerminal => stdout.hasTerminal;

  @override
  bool get supportsAnsiEscapes =>
      stdout.supportsAnsiEscapes || io.Platform.isAndroid;

  @override
  int get terminalColumns {
    try {
      return stdout.terminalColumns;
    } on Exception {
      throw const StdoutException('terminalColumns is not supported');
    }
  }

  @override
  void writeln(String message) => debugPrint(message);
}
