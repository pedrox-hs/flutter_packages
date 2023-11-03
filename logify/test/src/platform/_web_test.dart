import 'package:logify/src/platform/_fake.dart';
import 'package:logify/src/platform/_web.dart';
import 'package:logify/src/platform/stdio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  test(
    'stdout log should be window.console.log',
    () {
      // assert
      expect(stdout.log, window.console.log);
    },
  );

  test(
    'stderr log should be window.console.error',
    () {
      // assert
      expect(stderr.log, window.console.error);
    },
  );

  group(WebStdout, () {
    late WebStdout sut;
    late WebLog mockWebLog;

    setUp(() {
      mockWebLog = _MockWebLog().call;
      sut = WebStdout(mockWebLog);
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
      verify(() => mockWebLog('message')).called(1);
    });
  });
}

abstract class _WebLog {
  void call(Object? arg);
}

class _MockWebLog extends Mock implements _WebLog {}
