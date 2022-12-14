import 'package:args/command_runner.dart' show Command;

import 'action.dart';

abstract class BaseCommand extends Command {
  @override
  Future<void> run() async {
    for (final act in actions()) {
      await act();
    }
  }

  List<Action> actions();
}
