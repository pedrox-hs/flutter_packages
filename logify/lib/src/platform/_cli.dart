import 'dart:io' as io show Stdout, stdout, stderr;

import 'package:meta/meta.dart';

import 'stdio.dart' show Stdout, StdoutException;

final stdout = CLIStdout(io.stdout);

final stderr = CLIStdout(io.stderr);

@visibleForTesting
class CLIStdout implements Stdout {
  const CLIStdout(this.stdout);

  final io.Stdout stdout;

  @override
  bool get supportsAnsiEscapes => stdout.supportsAnsiEscapes;

  @override
  bool get hasTerminal => stdout.hasTerminal;

  @override
  int get terminalColumns {
    try {
      return stdout.terminalColumns;
    } on Exception {
      throw const StdoutException('terminalColumns is not supported');
    }
  }

  @override
  void writeln(String message) => stdout.writeln(message);
}
