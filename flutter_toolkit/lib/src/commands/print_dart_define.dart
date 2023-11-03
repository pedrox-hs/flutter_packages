import 'package:args/args.dart';

import '../core/command.dart';
import '../env.dart';
import '../utils/pubspec.dart';
import 'actions/print_dart_define.dart';

const _fromFiles = 'from-files';
const _fromPlatformExpr = 'from-platform-expr';
const _separator = 'separator';

class PrintDartDefineCommand extends BaseCommand<IDartDefineConfig> {
  PrintDartDefineCommand()
      : super(
          name: 'dart-define',
          description: 'Print env variables from .env using dart-define format',
          adapter: _Adapter(),
        );

  @override
  List<Action> actions() => [
        PrintDartDefine(args).call,
      ];
}

class _ArgOptions implements IDartDefineConfig {
  const _ArgOptions({
    required this.files,
    required this.platformExpr,
    required this.outputSeparator,
  });

  factory _ArgOptions.from(ArgResults args) => _ArgOptions(
        files: args[_fromFiles],
        platformExpr: args[_fromPlatformExpr],
        outputSeparator: args[_separator],
      );

  @override
  final List<String> files;
  @override
  final List<String> platformExpr;
  @override
  final String outputSeparator;
}

class _Adapter extends IArgParserAdapter<IDartDefineConfig> {
  @override
  ArgParser parser(ArgParser parser) => parser
    ..addMultiOption(
      _fromFiles,
      abbr: 'f',
      help: 'Path of environment files',
      defaultsTo: envFiles,
    )
    ..addMultiOption(
      _fromPlatformExpr,
      abbr: 'p',
      help: 'Includes platform environment that satisfy the expression',
      defaultsTo: ['^${pubspec.name.toUpperCase()}_'],
    )
    ..addOption(
      _separator,
      abbr: 's',
      help: 'Output separator',
      defaultsTo: ' ',
    );

  @override
  IDartDefineConfig fromResults(ArgResults results) =>
      _ArgOptions.from(results);
}
