enum Level { debug, info, wtf, warn, error }

extension LevelExt on Level {
  String get emoji {
    switch (this) {
      case Level.debug:
        return '🤖';
      case Level.info:
        return '🆗';
      case Level.wtf:
        return '🤔';
      case Level.warn:
        return '📢';
      case Level.error:
        return '🚨';
    }
  }

  int get color {
    switch (this) {
      case Level.debug:
        return Color.lightCyan;
      case Level.info:
        return Color.blue;
      case Level.wtf:
        return Color.lightGray;
      case Level.warn:
        return Color.yellow;
      case Level.error:
        return Color.red;
    }
  }

  String decorate(String text, {bool colorize = true}) =>
      '$emoji ${colorize ? _colorize(text) : text}';

  String _colorize(String text) => '\x1B[1;${color}m$text\x1B[0m';
}

abstract class Color {
  static int red = 31;
  static int yellow = 33;
  static int blue = 34;
  static int lightGray = 37;
  static int lightCyan = 96;
}
