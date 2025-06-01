import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:shic/shic.dart';

void main() {
  group('RequestExt', () {
    test('should copy request', () {
      // arrange
      final request = Request('GET', Uri.parse('https://example.com'))
        ..headers['foo'] = 'bar';

      // act
      final copy = request.copyWith(
        url: Uri.parse('https://example.org'),
        headers: {'baz': 'qux'},
      );

      // assert
      expect(copy.method, request.method);
      expect(copy.url, Uri.parse('https://example.org'));
      expect(copy.headers, {'foo': 'bar', 'baz': 'qux'});
    });

    test('should copy multipart request', () {
      // arrange
      final request = MultipartRequest('POST', Uri.parse('https://example.com'))
        ..fields['foo'] = 'bar';

      // act
      final copy = request.copyWith(
        url: Uri.parse('https://example.org'),
        headers: {'baz': 'qux'},
      );

      // assert
      expect(copy.method, request.method);
      expect(copy.url, Uri.parse('https://example.org'));
      expect(copy.fields, {'foo': 'bar'});
      expect(copy.headers, {'baz': 'qux'});
    });

    test('should copy streamed request', () {
      // arrange
      final request = StreamedRequest('POST', Uri.parse('https://example.com'));

      // act
      final copy = request.copyWith(
        url: Uri.parse('https://example.org'),
        headers: {'baz': 'qux'},
      );

      // assert
      expect(copy.method, request.method);
      expect(copy.url, Uri.parse('https://example.org'));
      expect(copy.headers, {'baz': 'qux'});
    });

    test('should throw UnsupportedError if request type is not supported', () {
      // arrange
      final request = _UnsupportedRequest();

      // act / assert
      expect(() => request.copyWith(), throwsUnsupportedError);
    });
  });
}

class _UnsupportedRequest extends Fake implements BaseRequest {}
