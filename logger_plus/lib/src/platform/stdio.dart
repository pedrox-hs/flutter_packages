import 'dart:developer' as dev show log;

import '_print.dart' show debugPrint;

/// A platform-specific stdout.
abstract class Stdout {
  bool get hasTerminal;

  int get terminalColumns;

  void writeln(String message);
}

/// A stdout that prints to the console.
/// It uses the `dart:developer` library.
class DevStdout implements Stdout {
  const DevStdout();

  @override
  final bool hasTerminal = false;

  @override
  final int terminalColumns = -1;

  @override
  void writeln(String message) => dev.log(message);
}

/// A stdout that prints to the console.
/// It uses the `debugPrint` implementation.
class PrintStdout implements Stdout {
  const PrintStdout();

  @override
  final bool hasTerminal = false;

  @override
  final int terminalColumns = -1;

  @override
  void writeln(String message) => debugPrint(message);
}