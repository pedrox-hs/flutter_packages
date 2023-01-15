import 'package:args/args.dart';
import 'package:args/command_runner.dart' show Command;

import 'action.dart';

export 'action.dart';

abstract class BaseCommand<Args> extends Command<int> {
  BaseCommand({
    required this.name,
    required this.description,
    required this.adapter,
  });

  @override
  final String name;

  @override
  final String description;

  final IArgParserAdapter adapter;

  late final args = adapter.fromResults(argResults!);

  @override
  late final argParser = adapter.parser(super.argParser);

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

abstract class IArgParserAdapter<T> {
  ArgParser parser(ArgParser parser);

  T fromResults(ArgResults results);
}
