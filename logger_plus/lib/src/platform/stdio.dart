import 'dart:developer' as dev show log;

/// A platform-specific stdout.
abstract class Stdout {
  bool get hasTerminal;

  bool get supportsAnsiEscapes;

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
  final bool supportsAnsiEscapes = true;

  @override
  int get terminalColumns =>
      throw StdoutException('terminalColumns is not supported');

  @override
  void writeln(String message) => dev.log(message);
}

class StdoutException implements Exception {
  const StdoutException(this.message);

  final String message;

  @override
  String toString() => 'StdoutException: $message';
}
