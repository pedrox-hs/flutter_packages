import 'dart:html' show window;

import 'stdio.dart' show Stdout, StdoutException;

const stdout = _Stdout();

const stderr = _Stdout();

class _Stdout implements Stdout {
  const _Stdout();

  @override
  final bool hasTerminal = false;

  @override
  final bool supportsAnsiEscapes = true;

  @override
  int get terminalColumns =>
      throw StdoutException('terminalColumns is not supported');

  @override
  void writeln(String message) => window.console.log(message);
}
