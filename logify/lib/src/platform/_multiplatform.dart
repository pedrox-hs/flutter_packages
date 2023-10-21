import 'dart:io' as io show stdout;

import 'print.dart' show debugPrint;
import 'stdio.dart' show Stdout, StdoutException;

const stdout = _PrintStdout();

const stderr = _PrintStdout();

/// A stdout that prints to the console.
/// It uses the `debugPrint` implementation.
class _PrintStdout implements Stdout {
  const _PrintStdout();

  @override
  bool get hasTerminal => io.stdout.hasTerminal;

  @override
  bool get supportsAnsiEscapes => io.stdout.supportsAnsiEscapes;

  @override
  int get terminalColumns {
    try {
      return io.stdout.terminalColumns;
    } on Exception {
      throw StdoutException('terminalColumns is not supported');
    }
  }

  @override
  void writeln(String message) => debugPrint(message);
}
