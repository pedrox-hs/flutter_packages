import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shic/shic.dart';

void main() {
  group('ClientExt', () {
    late Client sut;

    setUpAll(() {
      registerFallbackValue(_FakeRequest());
    });

    setUp(() async {
      sut = _MockClient();
    });

    test('upload should send multipart request correctly', () async {
      // arrange
      final url = Uri.parse('https://example.com');
      final files = [
        MultipartFile.fromBytes('foo', [1, 2, 3]),
        MultipartFile.fromBytes('bar', [4, 5, 6]),
      ];
      final fields = {'foo': 'bar', 'baz': 'qux'};

      when(() => sut.send(any())).thenAnswer(
        (_) async => StreamedResponse(ByteStream.fromBytes([]), 201),
      );

      // act
      await sut.upload(url, files, fields: fields);

      // assert
      final verifier = verify(() => sut.send(captureAny()))..called(1);
      expect(verifier.captured.first, isA<MultipartRequest>());

      final request = verifier.captured.first as MultipartRequest;
      expect(request.url, url);
      expect(request.files, files);
      expect(request.fields, fields);
    });
  });
}

class _MockClient extends Mock implements Client {}

class _FakeRequest extends Fake implements BaseRequest {}
