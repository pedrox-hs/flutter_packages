import 'dart:html' show window;

import 'stdio.dart' show Stdout;

const stdout = _Stdout();

const stderr = _Stdout();

class _Stdout implements Stdout {
  const _Stdout();

  @override
  final bool hasTerminal = false;

  @override
  final int terminalColumns = -1;

  @override
  void writeln(String message) => window.console.log(message);
}
