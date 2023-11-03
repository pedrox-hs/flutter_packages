// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Original source:
// https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/foundation/print.dart

// This file implements debugPrint in terms of print, so avoiding
// calling "print" is sort of a non-starter here...
// ignore_for_file: avoid_print

import 'dart:async' show Completer, Timer;
import 'dart:collection' show Queue;

/// Signature for [debugPrint] implementations.
///
/// If a [wrapWidth] is provided, each line of the [message] is word-wrapped to
/// that width. (Lines may be separated by newline characters, as in '\n'.)
///
/// By default, this function very crudely attempts to throttle the rate at
/// which messages are sent to avoid data loss on Android. This means that
/// interleaving calls to this function (directly or indirectly via, e.g.,
/// [debugDumpRenderTree] or [debugDumpApp]) and to the Dart [print] method can
/// result in out-of-order messages in the logs.
///
/// The implementation of this function can be replaced by setting the
/// [debugPrint] variable to a new implementation that matches the
/// [DebugPrintCallback] signature. For example, flutter_test does this.
///
/// The default value is [debugPrintThrottled]. For a version that acts
/// identically but does not throttle, use [debugPrintSynchronously].
typedef DebugPrintCallback = void Function(String? message);

/// Prints a message to the console, which you can access using the "flutter"
/// tool's "logs" command ("flutter logs").
///
/// See also:
///
///   * [DebugPrintCallback], for function parameters and usage details.
DebugPrintCallback debugPrint = debugPrintThrottled;

/// Implementation of [debugPrint] that throttles messages. This avoids dropping
/// messages on platforms that rate-limit their logging (for example, Android).
void debugPrintThrottled(String? message) {
  final List<String> messageLines = message?.split('\n') ?? <String>['null'];
  _debugPrintBuffer.addAll(messageLines);
  if (!_debugPrintScheduled) {
    _debugPrintTask();
  }
}
int _debugPrintedCharacters = 0;
const int _kDebugPrintCapacity = 12 * 1024;
const Duration _kDebugPrintPauseTime = Duration(seconds: 1);
final Queue<String> _debugPrintBuffer = Queue<String>();
final Stopwatch _debugPrintStopwatch = Stopwatch();
Completer<void>? _debugPrintCompleter;
bool _debugPrintScheduled = false;
void _debugPrintTask() {
  _debugPrintScheduled = false;
  if (_debugPrintStopwatch.elapsed > _kDebugPrintPauseTime) {
    _debugPrintStopwatch.stop();
    _debugPrintStopwatch.reset();
    _debugPrintedCharacters = 0;
  }
  while (_debugPrintedCharacters < _kDebugPrintCapacity && _debugPrintBuffer.isNotEmpty) {
    final String line = _debugPrintBuffer.removeFirst();
    _debugPrintedCharacters += line.length;
    print(line);
  }
  if (_debugPrintBuffer.isNotEmpty) {
    _debugPrintScheduled = true;
    _debugPrintedCharacters = 0;
    Timer(_kDebugPrintPauseTime, _debugPrintTask);
    _debugPrintCompleter ??= Completer<void>();
  } else {
    _debugPrintStopwatch.start();
    _debugPrintCompleter?.complete();
    _debugPrintCompleter = null;
  }
}

/// A Future that resolves when there is no longer any buffered content being
/// printed by [debugPrintThrottled] (which is the default implementation for
/// [debugPrint], which is used to report errors to the console).
Future<void> get debugPrintDone => _debugPrintCompleter?.future ?? Future<void>.value();
