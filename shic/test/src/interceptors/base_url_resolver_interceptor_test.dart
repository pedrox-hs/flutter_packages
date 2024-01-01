import 'package:flutter_mock_web_server/flutter_mock_web_server.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:shic/shic.dart';

void main() {
  group(ResolveBaseUrlInterceptor, () {
    late Client client;
    late MockWebServer server;

    setUp(() async {
      server = MockWebServer();
      await server.start();
      server.enqueue(httpCode: 201, body: '');

      client = InterceptableClient(
        interceptors: [
          ResolveBaseUrlInterceptor(Uri.parse(server.url)),
        ],
      );
    });

    tearDown(() async {
      await server.shutdown();
    });

    test(
      'should resolve base url',
      () async {
        // act
        final response = await client.get(Uri.parse('/foo'));

        // assert
        expect(response.request?.url.toString(), '${server.url}/foo');
      },
    );

    test(
      'should not resolve base url if url has scheme',
      () async {
        // arrange
        final url = '${server.url}/foo/bar';

        // act
        final response = await client.get(Uri.parse(url));

        // assert
        expect(response.request?.url.toString(), url);
      },
    );
  });
}
