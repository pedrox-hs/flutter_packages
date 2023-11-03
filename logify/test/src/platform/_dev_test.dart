import 'dart:async';

import 'package:logify/src/platform/_dev.dart';
import 'package:logify/src/platform/stdio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  group(DevStdout, () {
    late DevStdout sut;
    late DevLog mockDevLog;

    setUp(() {
      mockDevLog = _MockDevLog().call;
      sut = DevStdout(mockDevLog);
    });

    test('hasTerminal should returns false', () {
      expect(sut.hasTerminal, false);
    });

    test('supportsAnsiEscapes shoud returns true', () {
      expect(sut.supportsAnsiEscapes, true);
    });

    test('terminalColumns shold throws StdoutException', () {
      expect(() => sut.terminalColumns, throwsA(isA<StdoutException>()));
    });

    test('writeln should call log', () {
      // act
      sut.writeln('message');

      // assert
      verify(() => mockDevLog('message')).called(1);
    });
  });
}

abstract class _DevLog {
  void call(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level,
    String name,
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  });
}

class _MockDevLog extends Mock implements _DevLog {}
