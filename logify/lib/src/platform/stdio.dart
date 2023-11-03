// coverage:ignore-file
/// A platform-specific stdout.
abstract class Stdout {
  bool get hasTerminal;

  bool get supportsAnsiEscapes;

  int get terminalColumns;

  void writeln(String message);
}

class StdoutException implements Exception {
  const StdoutException(this.message);

  final String message;

  @override
  String toString() => 'StdoutException: $message';
}
