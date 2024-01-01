import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:shic/shic.dart';

void main() {
  group('ResponseExt', () {
    test(
      'bodyJson should parse json correctly',
      () {
        // arrange
        final expected = {'foo': 'bar'};
        final response = Response('{"foo": "bar"}', 200);

        // act
        final actual = response.bodyJson;

        // assert
        expect(actual, expected);
      },
    );
  });

  group('StreamedResponseExt', () {
    test('body should return body as string', () async {
      // arrange
      final expected = 'Hello, world!';
      final response = StreamedResponse(
        Stream.value(expected.codeUnits),
        200,
      );

      // act
      final actual = await response.body;

      // assert
      expect(actual, expected);
    });

    test(
      'bodyJson should parse json correctly',
      () async {
        // arrange
        final expected = {'foo': 'bar'};
        final response = StreamedResponse(
          Stream.value('{"foo": "bar"}'.codeUnits),
          200,
        );

        // act
        final actual = await response.bodyJson;

        // assert
        expect(actual, expected);
      },
    );
  });

  group('FutureResponseExt', () {
    test(
      'mapJsonWith should map json correctly',
      () async {
        // arrange
        final expected = {'foo': 'bar', 'baz': 'qux'};
        final response = Future.value(Response('{"foo": "bar"}', 200));

        // act
        final actual = await response.mapJsonWith(
          (Map<String, dynamic> json) => {...json, 'baz': 'qux'},
        );

        // assert
        expect(actual, expected);
      },
    );
  });
}
