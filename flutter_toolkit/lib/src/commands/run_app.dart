import 'package:args/args.dart';

import '../core/command.dart';
import 'actions/fvm_flutter_run.dart';

class RunAppCommand extends BaseCommand<List<String>> {
  RunAppCommand()
      : super(
          name: 'run-app',
          description: 'Proxy to FVM passing .env variables as arguments',
          adapter: _Adapter(),
        );

  @override
  List<Action> actions() => [
        FvmFlutterRun(flutterRunArgs: argResults!.arguments).call,
      ];
}

class _Adapter extends IArgParserAdapter<List<String>> {
  @override
  ArgParser parser(ArgParser parser) => ArgParser.allowAnything();

  @override
  List<String> fromResults(ArgResults results) => results.arguments;
}
