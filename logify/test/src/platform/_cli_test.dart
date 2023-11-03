import 'dart:io' as io show stdout, stderr, Stdout;
import 'dart:math';

import 'package:logify/src/platform/_cli.dart';
import 'package:logify/src/platform/stdio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  test(
    'stdout log should be window.console.log',
    () {
      // assert
      expect(stdout.stdout, io.stdout);
    },
  );

  test(
    'stderr log should be window.console.error',
    () {
      // assert
      expect(stderr.stdout, io.stderr);
    },
  );

  group(CLIStdout, () {
    late CLIStdout sut;
    late io.Stdout mockStdout;

    setUp(() {
      mockStdout = _MockStdout();
      sut = CLIStdout(mockStdout);
    });

    tearDown(() {
      reset(mockStdout);
    });

    test(
      'hasTerminal should returns stdout.hasTerminal',
      () {
        // arrange
        final expected = Random().nextBool();
        when(() => mockStdout.hasTerminal).thenReturn(expected);

        // act
        final actual = sut.hasTerminal;

        // assert
        expect(actual, expected);
        verify(() => mockStdout.hasTerminal).called(1);
      },
    );

    test(
      'supportsAnsiEscapes shoud returns stdout.supportsAnsiEscapes',
      () {
        // arrange
        final expected = Random().nextBool();
        when(() => mockStdout.supportsAnsiEscapes).thenReturn(expected);

        // act
        final actual = sut.supportsAnsiEscapes;

        // assert
        expect(actual, expected);
        verify(() => mockStdout.supportsAnsiEscapes).called(1);
      },
    );

    test(
      'terminalColumns shold returns stdout.terminalColumns',
      () {
        // arrange
        final expected = Random().nextInt(100);
        when(() => mockStdout.terminalColumns).thenReturn(expected);

        // act
        final actual = sut.terminalColumns;

        // assert
        expect(actual, expected);
        verify(() => mockStdout.terminalColumns).called(1);
      },
    );

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

    test(
      'writeln should call stdout.writeln',
      () {
        // arrange
        final message = 'message';

        // act
        sut.writeln(message);

        // assert
        verify(() => mockStdout.writeln(message)).called(1);
      },
    );
  });
}

class _MockStdout extends Mock implements io.Stdout {}
