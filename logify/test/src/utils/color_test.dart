import 'package:logify/src/utils/color.dart';
import 'package:test/test.dart';

import '../../helpers.dart';

void main() {
  group(ConsoleColor, () {
    const testValues = {
      ConsoleColor.black(): [
        '\x1B[0;30mdefault\x1B[0m',
        '\x1B[0;30mnormal\x1B[0m',
        '\x1B[1;30mbold\x1B[0m',
        '\x1B[0;30mlight\x1B[0m',
        '\x1B[0;90mhighlighted\x1B[0m',
      ],
      ConsoleColor.red(): [
        '\x1B[0;31mdefault\x1B[0m',
        '\x1B[0;31mnormal\x1B[0m',
        '\x1B[1;31mbold\x1B[0m',
        '\x1B[0;31mlight\x1B[0m',
        '\x1B[0;91mhighlighted\x1B[0m',
      ],
      ConsoleColor.green(): [
        '\x1B[0;32mdefault\x1B[0m',
        '\x1B[0;32mnormal\x1B[0m',
        '\x1B[1;32mbold\x1B[0m',
        '\x1B[0;32mlight\x1B[0m',
        '\x1B[0;92mhighlighted\x1B[0m',
      ],
      ConsoleColor.yellow(): [
        '\x1B[0;33mdefault\x1B[0m',
        '\x1B[0;33mnormal\x1B[0m',
        '\x1B[1;33mbold\x1B[0m',
        '\x1B[0;33mlight\x1B[0m',
        '\x1B[0;93mhighlighted\x1B[0m',
      ],
      ConsoleColor.blue(): [
        '\x1B[0;34mdefault\x1B[0m',
        '\x1B[0;34mnormal\x1B[0m',
        '\x1B[1;34mbold\x1B[0m',
        '\x1B[0;34mlight\x1B[0m',
        '\x1B[0;94mhighlighted\x1B[0m',
      ],
      ConsoleColor.magenta(): [
        '\x1B[0;35mdefault\x1B[0m',
        '\x1B[0;35mnormal\x1B[0m',
        '\x1B[1;35mbold\x1B[0m',
        '\x1B[0;35mlight\x1B[0m',
        '\x1B[0;95mhighlighted\x1B[0m',
      ],
      ConsoleColor.cyan(): [
        '\x1B[0;36mdefault\x1B[0m',
        '\x1B[0;36mnormal\x1B[0m',
        '\x1B[1;36mbold\x1B[0m',
        '\x1B[0;36mlight\x1B[0m',
        '\x1B[0;96mhighlighted\x1B[0m',
      ],
      ConsoleColor.gray(): [
        '\x1B[0;37mdefault\x1B[0m',
        '\x1B[0;37mnormal\x1B[0m',
        '\x1B[1;37mbold\x1B[0m',
        '\x1B[0;37mlight\x1B[0m',
        '\x1B[0;97mhighlighted\x1B[0m',
      ],
      ConsoleColor.none(): [
        'default',
        'normal',
        'bold',
        'light',
        'highlighted',
      ],
    };

    const variations = ['default', 'normal', 'bold', 'light', 'highlighted'];

    testValues.forEach((color, expected) {
      for (var i = 0; i < variations.length; i++) {
        final variation = variations[i];

        test(
          'wrap should return the correct ANSI escape codes when $color is $variation',
          () {
            // arrange
            final variationColor =
                variation != 'default'
                    ? invokeInstanceGetter<ConsoleColor>(color, variation)
                    : color;

            // act
            final actual = variationColor.wrap(variation);

            // assert
            expect(actual, expected[i]);
          },
        );
      }
    });
  });
}
