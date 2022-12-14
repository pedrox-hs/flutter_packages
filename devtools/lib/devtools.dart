library devtools;

import 'package:args/command_runner.dart' show Command, CommandRunner;

import 'src/commands/project_setup.dart';
import 'src/ext/args.dart';

final commands = <Command>[
  ProjectSetupCommand(),
];

final runner = CommandRunner(
  'devtools',
  'A set of commands to improve development productivity.',
)..addCommands(commands);
