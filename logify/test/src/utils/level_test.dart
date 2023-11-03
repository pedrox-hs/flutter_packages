import 'package:logging/logging.dart';
import 'package:logify/utils.dart';
import 'package:test/test.dart';

void main() {
  group('LevelExt', () {
    const allLevels = Level.LEVELS;

    final allEmojis = {
      Level.ALL: '🤷‍♂️',
      Level.FINEST: '🔬',
      Level.FINER: '🔎',
      Level.FINE: '👌',
      Level.CONFIG: '🔧',
      Level.INFO: '📝',
      Level.WARNING: '📣',
      Level.SEVERE: '🚨',
      Level.SHOUT: '☠️ ',
      Level.OFF: '🤷‍♂️',
    };

    final allColors = {
      Level.ALL: 'ALL',
      Level.FINEST: '\x1B[0;37mFINEST\x1B[0m',
      Level.FINER: '\x1B[0;36mFINER\x1B[0m',
      Level.FINE: '\x1B[1;92mFINE\x1B[0m',
      Level.CONFIG: '\x1B[0;97mCONFIG\x1B[0m',
      Level.INFO: '\x1B[1;34mINFO\x1B[0m',
      Level.WARNING: '\x1B[0;93mWARNING\x1B[0m',
      Level.SEVERE: '\x1B[1;91mSEVERE\x1B[0m',
      Level.SHOUT: '\x1B[1;95mSHOUT\x1B[0m',
      Level.OFF: 'OFF',
    };

    for (final level in allLevels) {
      final expectedEmoji = allEmojis[level];
      final expectedColor = allColors[level];

      test(
        'emoji should returns ${expectedEmoji} when level is ${level}',
        () {
          expect(level.emoji, expectedEmoji);
        },
      );

      test(
        'color wrap should returns the correct ANSI escape codes when level is ${level}',
        () {
          expect(level.color.wrap(level.name), expectedColor);
        },
      );
    }
  });
}
