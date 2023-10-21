import 'dart:io' as io show Stdout, stdout, stderr;

import 'stdio.dart' show Stdout;

final stdout = _Stdout(io.stdout);

final stderr = _Stdout(io.stderr);

class _Stdout implements Stdout {
  const _Stdout(this.stdout);

  final io.Stdout stdout;

  @override
  bool get hasTerminal => stdout.hasTerminal;

  @override
  int get terminalColumns => stdout.terminalColumns;

  @override
  void writeln(String message) => stdout.writeln(message);
}
