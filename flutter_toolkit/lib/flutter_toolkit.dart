library flutter_toolkit;

import 'package:args/command_runner.dart' show Command, CommandRunner;

import 'src/commands/project_setup.dart';
import 'src/commands/run_app.dart';
import 'src/ext/args.dart';

final commands = <Command>[
  ProjectSetupCommand(),
  RunAppCommand(),
];

final runner = CommandRunner<int>(
  'flutter_toolkit',
  'A set of commands to improve development productivity.',
)..addCommands(commands);
