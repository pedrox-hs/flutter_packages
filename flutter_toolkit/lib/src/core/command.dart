import 'package:args/command_runner.dart' show Command;

import 'action.dart';

export 'action.dart';

abstract class BaseCommand extends Command<int> {
  @override
  Future<int> run() async {
    try {
      for (final act in actions()) {
        await act();
      }
    } catch (e) {
      return 1;
    }
    return 0;
  }

  List<Action> actions();
}
