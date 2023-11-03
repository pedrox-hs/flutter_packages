import 'dart:async';

import 'package:logging/logging.dart';
import 'package:logify/src/log_recorder.dart';
import 'package:logify/src/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  group(Log, () {
    late Logger mockLogger;

    setUpAll(() {
      registerFallbackValue(_FakeStackTace());
    });

    setUp(() {
      mockLogger = _MockLogger();
      defaultLogger = mockLogger;
    });

    final testValuesForErrors = [
      ['e', 'severe'],
      ['wtf', 'shout'],
    ];

    final testValues = [
      ['v', 'finest'],
      ['d', 'finer'],
      ['ok', 'fine'],
      ['config', 'config'],
      ['i', 'info'],
      ['w', 'warning'],
      ...testValuesForErrors,
    ];

    for (final testValue in testValues) {
      final logMethod = testValue[0];
      final loggerMethod = testValue[1];

      test('.${logMethod} should call Logger::${loggerMethod}', () {
        // arrange
        final args = ['message', 'error', StackTrace.current];

        when(
          () => invokeInstanceMethod(
            mockLogger,
            loggerMethod,
            [any(), any(), any()],
          ),
        ).thenReturn(null);

        // act
        invokeStaticMethod(Log, logMethod, args);

        // assert
        verify(
          () => invokeInstanceMethod(mockLogger, loggerMethod, args),
        ).called(1);
      });

      test(
        '.${logMethod} should call Logger::${loggerMethod} with a default stackTrace',
        () {
          // arrange
          final args = ['message', 'error'];

          when(
            () => invokeInstanceMethod(
              mockLogger,
              loggerMethod,
              [any(), any(), any()],
            ),
          ).thenReturn(null);

          // act
          invokeStaticMethod(Log, logMethod, args);

          // assert
          final verifier = verify(
            () => invokeInstanceMethod(
              mockLogger,
              loggerMethod,
              [...args, captureAny<StackTrace>()],
            ),
          );
          verifier.called(1);
          final captured = verifier.captured.single as Trace?;
          expect(captured, isNotNull);
          expect(captured?.frames.first.member, '_ClassMirror._invoke');
        },
      );
    }

    for (final testValue in testValuesForErrors) {
      final logMethod = testValue[0];
      final loggerMethod = testValue[1];

      test(
        'when error is null .${logMethod} should call Logger::${loggerMethod} with message as error',
        () {
          // arrange
          const message = 'Error message';
          final args = [message];

          when(
            () => invokeInstanceMethod(
              mockLogger,
              loggerMethod,
              [any(), any(), any()],
            ),
          ).thenReturn(null);

          // act
          invokeStaticMethod(Log, logMethod, args);

          // assert
          final verifier = verify(
            () => invokeInstanceMethod(
              mockLogger,
              loggerMethod,
              [message, captureAny(), any()],
            ),
          );
          verifier.called(1);
          final captured = verifier.captured.single;
          expect(captured, equals('Error message'));
        },
      );

      test(
        'when error and message are null .${logMethod} should call Logger::${loggerMethod} with non null error',
        () {
          // arrange
          final args = [null];

          when(
            () => invokeInstanceMethod(
              mockLogger,
              loggerMethod,
              [any(), any(), any()],
            ),
          ).thenReturn(null);

          // act
          invokeStaticMethod(Log, logMethod, args);

          // assert
          final verifier = verify(
            () => invokeInstanceMethod(
              mockLogger,
              loggerMethod,
              [any(), captureAny(), any()],
            ),
          );
          verifier.called(1);
          final captured = verifier.captured.single;
          expect(captured, isNotNull);
        },
      );
    }

    test(
      'clearListeners should call Logger::clearListeners',
      () {
        // arrange
        when(() => mockLogger.clearListeners()).thenReturn(null);

        // act
        Log.clearListeners();

        // assert
        verify(() => mockLogger.clearListeners()).called(1);
      },
    );

    test(
      'listen should call Logger::onRecord::listen',
      () {
        // arrange
        final recorder = _FakeLogRecorder();
        final mockStream = _MockStream();
        final subscription = _FakeStreamSubscription();

        when(() => mockLogger.onRecord).thenAnswer((_) => mockStream);

        when(() => mockStream.listen(any())).thenReturn(subscription);

        // act
        final actual = Log.listen(recorder);

        // assert
        verify(() => mockStream.listen(recorder.call)).called(1);
        expect(actual, equals(subscription));
      },
    );
  });
}

class _MockLogger extends Mock implements Logger {}

class _MockStream extends Mock implements Stream<LogRecord> {}

class _FakeStackTace extends Fake implements StackTrace {}

class _FakeLogRecorder extends Fake implements LogRecorder {}

class _FakeStreamSubscription extends Fake
    implements StreamSubscription<LogRecord> {}
