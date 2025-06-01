import 'package:logging/logging.dart';
import 'package:logify/src/log_recorder.dart';
import 'package:logify/src/platform/stdio.dart';
import 'package:logify/src/recorder/console_log_recorder.dart';
import 'package:logify/utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  group(ConsoleLogRecorder, () {
    late LogRecorder sut;

    late Stdout stdout;
    late Stdout stderr;

    setUp(() {
      stdout = _MockStdout();
      stderr = _MockStdout();

      sut = ConsoleLogRecorder(stdout: stdout, stderr: stderr);
    });

    test('should print the message to stdout if the level is not severe', () {
      // arrange
      final record = LogRecord(
        Level.INFO,
        'some info message',
        'logger_name',
        'error',
        StackTrace.current,
      );
      const expected = '[  INFO   ] some info message';

      // act
      sut(record);

      // assert
      final verifier = verify(() => stdout.writeln(captureAny()));
      verifier.called(1);
      verifyNever(() => stderr.writeln(any()));
      expect(verifier.captured.single, expected);
    });

    test('should print the message to stderr if the level is severe', () {
      // arrange
      final record = LogRecord(
        Level.SEVERE,
        'severe message',
        'logger_name',
        'error',
        StackTrace.current,
      );
      final expected = '[ SEVERE  ] severe message\nerror\n${record.trace}';

      // act
      sut(record);

      // assert
      final verifier = verify(() => stderr.writeln(captureAny()));
      verifier.called(1);
      verifyNever(() => stdout.writeln(any()));
      expect(verifier.captured.single, expected);
    });
  });
}

class _MockStdout extends Mock implements Stdout {}
