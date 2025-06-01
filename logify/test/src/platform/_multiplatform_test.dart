import 'dart:async';
import 'dart:io' as io show stdout, stderr, Stdout;
import 'dart:math';

import 'package:logify/src/platform/_multiplatform.dart';
import 'package:logify/src/platform/stdio.dart';
import 'package:logify/src/utils/print.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../helpers.dart';

void main() {
  test('stdout log should be window.console.log', () {
    // assert
    expect(stdout.stdout, io.stdout);
  });

  test('stderr log should be window.console.error', () {
    // assert
    expect(stderr.stdout, io.stderr);
  });

  group(PrintStdout, () {
    late PrintStdout sut;
    late io.Stdout mockStdout;

    setUp(() {
      mockStdout = _MockStdout();
      sut = PrintStdout(mockStdout);
    });

    tearDown(() {
      reset(mockStdout);
    });

    test('hasTerminal should returns stdout.hasTerminal', () {
      // arrange
      final expected = Random().nextBool();
      when(() => mockStdout.hasTerminal).thenReturn(expected);

      // act
      final actual = sut.hasTerminal;

      // assert
      expect(actual, expected);
      verify(() => mockStdout.hasTerminal).called(1);
    });

    test('supportsAnsiEscapes shoud returns stdout.supportsAnsiEscapes', () {
      // arrange
      final expected = Random().nextBool();
      when(() => mockStdout.supportsAnsiEscapes).thenReturn(expected);

      // act
      final actual = sut.supportsAnsiEscapes;

      // assert
      expect(actual, expected);
      verify(() => mockStdout.supportsAnsiEscapes).called(1);
    });

    test('terminalColumns shold returns stdout.terminalColumns', () {
      // arrange
      final expected = Random().nextInt(100);
      when(() => mockStdout.terminalColumns).thenReturn(expected);

      // act
      final actual = sut.terminalColumns;

      // assert
      expect(actual, expected);
      verify(() => mockStdout.terminalColumns).called(1);
    });

    test(
      'terminalColumns shold throws StdoutException when real stdout throw error',
      () {
        // arrange
        when(() => mockStdout.terminalColumns).thenThrow(Exception());

        // act
        final actual = () => sut.terminalColumns;

        // assert
        expect(actual, throwsA(isA<StdoutException>()));
        verify(() => mockStdout.terminalColumns).called(1);
      },
    );

    test('writeln should print all messages', () async {
      // arrange
      const printSize = (12 * 1024) + 1;
      final message = Random().nextString(printSize);
      final expectedMessage = message * 2;

      // act
      String actual = '';
      runZoned(
        () {
          sut.writeln(message);
          sut.writeln(message);
        },
        zoneSpecification: ZoneSpecification(
          print: (_, __, ___, message) {
            actual += message;
          },
        ),
      );

      // assert
      await debugPrintDone;
      expect(actual, expectedMessage);
    });
  });
}

class _MockStdout extends Mock implements io.Stdout {}
