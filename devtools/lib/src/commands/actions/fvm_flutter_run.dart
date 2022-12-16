import 'dart:io';

// ignore: implementation_imports
import 'package:fvm/src/runner.dart';

import '../../core/command.dart';
import '../../env.dart';

class FvmFlutterRun extends IAction {
  // ignore: invalid_use_of_visible_for_testing_member
  Map<String, String> get _env => env.map;

  Iterable<String> get dartDefine =>
      _env.entries.expand((e) => ['--dart-define', '${e.key}=${e.value}']);

  final List<String> flutterRunArgs;

  FvmFlutterRun({required this.flutterRunArgs});

  @override
  Future<void> call() async {
    final exitCode = await FvmCommandRunner().run([
      'flutter',
      'run',
      ...flutterRunArgs,
      ...dartDefine,
    ]);
    exit(exitCode);
  }
}
