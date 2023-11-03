import 'package:logging/logging.dart';
import 'package:logify/src/log_recorder.dart';
import 'package:logify/src/platform/stdio.dart';
import 'package:logify/src/recorder/debug_log_recorder.dart';
import 'package:logify/utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  group(DebugLogRecorder, () {
    late LogRecorder sut;

    late Stdout stdout;
    late Stdout stderr;

    setUp(() {
      stdout = _MockStdout();
      stderr = _MockStdout();

      sut = DebugLogRecorder(
        stdout: stdout,
        stderr: stderr,
      );

      when(() => stdout.terminalColumns).thenReturn(130);
      when(() => stderr.terminalColumns).thenReturn(130);
    });

    test(
      'should print the message to stdout if the level is not severe',
      () {
        // arrange
        final record = LogRecord(
          Level.INFO,
          'some info message',
          'logger_name',
          'error',
          StackTrace.current,
        );
        final expected =
            '📝 \x1B[1;34msome info message\x1B[0m \x1B[0;34m------ ${record.location}\x1B[0m';
        when(() => stdout.supportsAnsiEscapes).thenReturn(true);
        when(() => stdout.hasTerminal).thenReturn(true);

        // act
        sut(record);

        // assert
        final verifier = verify(() => stdout.writeln(captureAny()));
        verifier.called(1);
        verifyNever(() => stderr.writeln(any()));
        expect(verifier.captured.single, expected);
      },
    );

    test(
      'should print the message to stderr if the level is severe',
      () {
        // arrange
        final record = LogRecord(
          Level.SEVERE,
          'some severe message',
          'logger_name',
          'error',
          StackTrace.current,
        );
        final expected =
            '🚨 \x1B[1;91msome severe message\x1B[0m \x1B[0;31m---- ${record.location}\x1B[0m\n\x1B[0;31merror\x1B[0m\n\x1B[0;31m${record.trace}\x1B[0m';
        when(() => stderr.supportsAnsiEscapes).thenReturn(true);
        when(() => stderr.hasTerminal).thenReturn(true);

        // act
        sut(record);

        // assert
        final verifier = verify(() => stderr.writeln(captureAny()));
        verifier.called(1);
        verifyNever(() => stdout.writeln(any()));
        expect(verifier.captured.single, expected);
      },
    );

    test(
      'should print not colorized message when supportsAnsiEscapes returns false',
      () {
        // arrange
        final record = LogRecord(
          Level.SEVERE,
          'some severe message',
          'logger_name',
          'error',
          StackTrace.current,
        );
        final expected =
            '🚨 some severe message ---- ${record.location}\nerror\n${record.trace}';
        when(() => stderr.supportsAnsiEscapes).thenReturn(false);
        when(() => stderr.hasTerminal).thenReturn(true);

        // act
        sut(record);

        // assert
        final verifier = verify(() => stderr.writeln(captureAny()));
        verifier.called(1);
        verifyNever(() => stdout.writeln(any()));
        expect(verifier.captured.single, expected);
      },
    );

    test(
      'should print not spaced location when hasTerminal returns false',
      () {
        // arrange
        final record = LogRecord(
          Level.INFO,
          'some info message',
          'logger_name',
        );
        final expected = '📝 some info message at ${record.location}';
        when(() => stdout.supportsAnsiEscapes).thenReturn(false);
        when(() => stdout.hasTerminal).thenReturn(false);

        // act
        sut(record);

        // assert
        final verifier = verify(() => stdout.writeln(captureAny()));
        verifier.called(1);
        verifyNever(() => stderr.writeln(any()));
        expect(verifier.captured.single, expected);
      },
    );
  });
}

class _MockStdout extends Mock implements Stdout {}
