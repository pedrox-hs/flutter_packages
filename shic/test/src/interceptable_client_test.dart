import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shic/shic.dart';

void main() {
  group(InterceptableClient, () {
    test('should create client with interceptor', () {
      // arrange
      final client = InterceptableClient(interceptors: [_MockInterceptor()]);

      // assert
      expect(client.interceptors.length, 1);
      expect(client.interceptors.first, isA<_MockInterceptor>());
    });

    group('withDefaultInterceptors', () {
      test('should add default interceptors', () {
        // arrange
        final client = InterceptableClient.withDefaultInterceptors(
          interceptors: [_MockInterceptor()],
        );

        // assert
        expect(client.interceptors.length, 3);
        expect(client.interceptors.first, isA<AssetsInterceptor>());
        expect(
          client.interceptors.elementAt(1),
          isA<NetworkConnectionInterceptor>(),
        );
        expect(client.interceptors.last, isA<_MockInterceptor>());
      });

      test('should add default interceptors when baseUrl is provided', () {
        // arrange
        final client = InterceptableClient.withDefaultInterceptors(
          baseUrl: Uri.parse('https://example.com'),
          interceptors: [_MockInterceptor()],
        );

        // assert
        expect(client.interceptors.length, 4);
        expect(client.interceptors.first, isA<AssetsInterceptor>());
        expect(
          client.interceptors.elementAt(1),
          isA<NetworkConnectionInterceptor>(),
        );
        expect(
          client.interceptors.elementAt(2),
          isA<ResolveBaseUrlInterceptor>(),
        );
        expect(client.interceptors.last, isA<_MockInterceptor>());
      });
    });

    group('send', () {
      late Client sut;

      late Client mockClient;
      late List<HttpInterceptor> mockInterceptors;

      setUpAll(() {
        registerFallbackValue(_FakeRequest());
      });

      setUp(() {
        sut = InterceptableClient(
          baseClient: mockClient = _MockClient(),
          interceptors:
              mockInterceptors = [_MockInterceptor(), _MockInterceptor()],
        );
      });

      test('should dispatch request to interceptors in order', () async {
        // arrange
        final request = Request('GET', Uri.parse('https://example.com'));
        final response = StreamedResponse(Stream.empty(), 200);
        when(() => mockInterceptors.first.intercept(any(), any())).thenAnswer(
          (invocation) async => invocation.positionalArguments[1](request),
        );
        when(() => mockInterceptors.last.intercept(any(), any())).thenAnswer(
          (invocation) async => invocation.positionalArguments[1](request),
        );
        when(
          () => mockClient.send(any()),
        ).thenAnswer((invocation) async => response);

        // act
        final actual = await sut.send(request);

        // assert
        verifyInOrder([
          () => mockInterceptors.first.intercept(request, any()),
          () => mockInterceptors.last.intercept(request, any()),
          () => mockClient.send(request),
        ]);
        expect(actual, response);
      });

      test(
        'should skip dispatching request to interceptors when one of them returns response',
        () async {
          // arrange
          final request = Request('GET', Uri.parse('https://example.com'));
          final response = StreamedResponse(Stream.empty(), 200);
          when(
            () => mockInterceptors.first.intercept(any(), any()),
          ).thenAnswer((invocation) async => response);

          // act
          final actual = await sut.send(request);

          // assert
          verify(() => mockInterceptors.first.intercept(request, any()));
          verifyNever(() => mockInterceptors.last.intercept(any(), any()));
          expect(actual, response);
        },
      );
    });
  });
}

class _MockClient extends Mock implements Client {}

class _MockInterceptor extends Mock implements HttpInterceptor {}

class _FakeRequest extends Fake implements BaseRequest {}
