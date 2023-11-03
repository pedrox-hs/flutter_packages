import 'package:logify/src/utils/string.dart';
import 'package:test/test.dart';

void main() {
  group('StringExt', () {
    test(
      'padBoth',
      () {
        // arrange
        final sut = 'hello';

        // act
        final result = sut.padBoth(10, '*');

        // assert
        expect(result, '**hello***');
      },
    );

    test(
      'format',
      () {
        // arrange
        final sut = '{0} {2} {0}';

        // act
        final result = sut.format(['foo', 'bar', 'baz', 'qux']);

        // assert
        expect(result, 'foo baz foo');
      },
    );

    test(
      'formatWithMap',
      () {
        // arrange
        final sut = 'hello {world}';

        // act
        final result = sut.formatWithMap({'world': 'foo'});

        // assert
        expect(result, 'hello foo');
      },
    );

    test(
      'formatWith',
      () {
        // arrange
        final sut = 'hello {world}';

        // act
        final result = sut.formatWith((key) => 'foo');

        // assert
        expect(result, 'hello foo');
      },
    );

    test(
      'formatWithParameterized',
      () {
        // arrange
        final sut = 'hello {0|world|foo|bar}';

        // act
        final result = sut.formatWithParameterized(
          (key, params) => params.join(', '),
        );

        // assert
        expect(result, 'hello world, foo, bar');
      },
    );
  });
}
