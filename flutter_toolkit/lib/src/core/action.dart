import 'dart:async';
import 'dart:io' show stdin, exit;

import 'package:meta/meta.dart';

typedef Action = FutureOr<void> Function();

@immutable
abstract class IAction {
  FutureOr<void> call();
}

@immutable
abstract class ConditionalAction implements IAction {
  bool get shouldRun;

  @override
  FutureOr<void> call() async {
    if (!shouldRun) return;
    await whenRequired();
  }

  Future<void> whenRequired();
}

@immutable
abstract class GrantedAction extends ConditionalAction {
  void requestPermission();

  void onDenied();

  Future<void> onAllowed();

  @override
  Future<void> whenRequired() async {
    requestPermission();
    if (_isDenied()) {
      onDenied();
      exit(1);
    }

    await onAllowed();
  }

  bool _isDenied() {
    final input = stdin.readLineSync()?.toString() ?? '';
    return input.isNotEmpty && input.toUpperCase() != 'Y';
  }
}
