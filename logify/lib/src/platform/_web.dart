import 'package:meta/meta.dart';

import '_fake.dart' if (dart.library.html) 'dart:html' show window;
import 'stdio.dart' show Stdout, StdoutException;

final stdout = WebStdout(window.console.log);

final stderr = WebStdout(window.console.error);

typedef WebLog = void Function(Object? arg);

@visibleForTesting
class WebStdout implements Stdout {
  const WebStdout(this.log);

  final WebLog log;

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
