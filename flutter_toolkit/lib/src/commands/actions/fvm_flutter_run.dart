import 'dart:io';

// ignore: implementation_imports
import 'package:fvm/src/runner.dart';

import '../../core/command.dart';
import '../../env.dart';

class FvmFlutterRun extends IAction {
  final List<String> flutterRunArgs;

  FvmFlutterRun({required this.flutterRunArgs});

  @override
  Future<void> call() async {
    final exitCode = await FvmCommandRunner().run([
      'flutter',
      'run',
      ...flutterRunArgs,
      ...env.toDartDefine(),
    ]);
    exit(exitCode);
  }
}
