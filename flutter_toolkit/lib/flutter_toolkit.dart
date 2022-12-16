library flutter_toolkit;

import 'package:args/command_runner.dart' show Command, CommandRunner;

import 'src/commands/print_dart_define.dart';
import 'src/commands/project_setup.dart';
import 'src/commands/run_app.dart';
import 'src/utils/args.dart';

final commands = <Command>[
  ProjectSetupCommand(),
  RunAppCommand(),
  PrintDartDefineCommand(),
];

final runner = CommandRunner<int>(
  'flutter_toolkit',
  'A set of commands to improve development productivity.',
)..addCommands(commands);
