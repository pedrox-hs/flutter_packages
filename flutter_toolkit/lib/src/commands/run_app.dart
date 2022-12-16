import 'package:args/args.dart';

import '../core/command.dart';
import 'actions/fvm_flutter_run.dart';

class RunAppCommand extends BaseCommand {
  @override
  String name = 'run-app';

  @override
  String description = 'Proxy to FVM passing .env variables as arguments';

  @override
  final argParser = ArgParser.allowAnything();

  @override
  List<Action> actions() => [
        FvmFlutterRun(flutterRunArgs: argResults!.arguments),
      ];
}
