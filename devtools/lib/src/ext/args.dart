import 'package:args/args.dart' show ArgParser;
import 'package:args/command_runner.dart' show CommandRunner, Command;

import '../env.dart';

extension RunnerExt on CommandRunner {
  void addCommands(List<Command> commands) {
    commands.forEach(addCommand);
  }
}

extension ArgParserExt on ArgParser {
  void addEnvOption(
    String name, {
    required String envName,
    required String help,
  }) =>
      addOption(
        name,
        help: help,
        mandatory: !env.isDefined(envName),
        defaultsTo: env[envName],
      );
}
