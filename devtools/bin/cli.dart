import 'package:args/command_runner.dart';
import 'package:devtools/devtools.dart';
import 'package:devtools/src/ext/runner.dart';

void main(List<String> args) {
  CommandRunner(
    'cli',
    'A set of commands to improve development productivity.',
  )
    ..addCommands(commands)
    ..run(args);
}
