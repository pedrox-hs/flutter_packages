import 'dart:io' show Process, stdout;

import 'package:process_run/shell.dart' show Shell;

import '../env.dart';

bool hasCommand(String executable) =>
    execSync('command', ['-v', executable]).isNotEmpty;

Future<void> exec(
  String script, {
  bool throwOnError = true,
  bool verbose = true,
}) async {
  await Shell(
    runInShell: true,
    environment: {'PATH': env.path},
    throwOnError: throwOnError,
    commandVerbose: false,
    verbose: verbose,
  ).run(script);
}

String execSync(String executable, [List<String> args = const []]) =>
    Process.runSync(
      executable,
      args,
      runInShell: true,
      environment: {'PATH': env.path},
    ).stdout.toString().trim();

/// Print to stdout
void p(Object? object) => stdout.write(object);
