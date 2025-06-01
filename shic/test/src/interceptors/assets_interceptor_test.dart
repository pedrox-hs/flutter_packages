import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_mock_web_server/flutter_mock_web_server.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:shic/shic.dart';

void main() {
  const serverResponse = 'Hello, from server!';

  group(AssetsInterceptor, () {
    late Client client;
    late MockWebServer server;

    setUp(() async {
      server = MockWebServer();
      await server.start();
      server.enqueue(httpCode: 200, body: serverResponse);

      client = InterceptableClient(
        interceptors: [AssetsInterceptor(bundle: _TestAssetBundle())],
      );
    });

    tearDown(() async {
      await server.shutdown();
    });

    test('should return asset response', () async {
      // arrange
      final url = Uri.parse('assets://foo/bar.txt');
      final expected = _TestAssetBundle.assetData;

      // act
      final response = await client.get(url);

      // assert
      expect(response.request?.url, url);
      expect(response.body, expected);
    });

    test('should return original response', () async {
      // arrange
      final url = Uri.parse(server.url);
      final expected = serverResponse;

      // act
      final response = await client.get(url);

      // assert
      expect(response.request?.url, url);
      expect(response.body, expected);
    });
  });
}

class _TestAssetBundle extends CachingAssetBundle {
  static const assetData = 'Hello, from asset bundle';
  static const assetPath = 'assets/foo/bar.txt';

  @override
  Future<ByteData> load(String key) async {
    if (key == assetPath) {
      return ByteData.view(utf8.encoder.convert(assetData).buffer);
    }
    return ByteData(0);
  }
}
