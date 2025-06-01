import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_mock_web_server/flutter_mock_web_server.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shic/shic.dart';

void main() {
  group(NetworkConnectionInterceptor, () {
    late Client client;
    late MockWebServer server;

    late Connectivity mockConnectivity;

    setUpAll(() {
      registerFallbackValue(_FakeRequest());
    });

    setUp(() async {
      server = MockWebServer();
      mockConnectivity = _MockConnectivity();

      await server.start();
      server.enqueue(httpCode: 201, body: '');

      client = InterceptableClient(
        interceptors: [
          NetworkConnectionInterceptor(
            networkInfo: NetworkInfo(mockConnectivity),
          ),
        ],
      );
    });

    tearDown(() async {
      await server.shutdown();
    });

    test('should make request successful when is connected', () async {
      // arrange
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => ConnectivityResult.wifi);

      // act
      final response = await client.get(Uri.parse('${server.url}/foo'));

      // assert
      expect(response.request?.url.toString(), '${server.url}/foo');
    });

    test('should throw NetworkConnectionException if disconnected', () async {
      // arrange
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => ConnectivityResult.none);

      // act
      final response = client.get(Uri.parse('/foo'));

      // assert
      expect(response, throwsA(isA<NetworkConnectionException>()));
    });

    test(
      'should throw NetworkConnectionException when client has SocketException',
      () async {
        // arrange
        final mockHttpClient = _MockHttpClient();
        final client = InterceptableClient(
          baseClient: mockHttpClient,
          interceptors: [
            NetworkConnectionInterceptor(
              networkInfo: NetworkInfo(mockConnectivity),
            ),
          ],
        );
        var connectivityResult = ConnectivityResult.wifi;
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => connectivityResult);
        when(() => mockHttpClient.send(any())).thenAnswer((invocation) async {
          connectivityResult = ConnectivityResult.none;
          throw SocketException('foo');
        });

        // act
        final response = client.get(Uri.parse('/foo'));

        // assert
        expectLater(response, throwsA(isA<NetworkConnectionException>()));
      },
    );
  });
}

class _MockHttpClient extends Mock implements Client {}

class _MockConnectivity extends Mock implements Connectivity {}

class _FakeRequest extends Fake implements BaseRequest {}
