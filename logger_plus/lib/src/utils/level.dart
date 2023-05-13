import 'package:logging/logging.dart';

import 'color.dart';

extension LevelExt on Level {
  String get emoji {
    if (this == Level.FINEST) return '🔬';
    if (this == Level.FINER) return '🔎';
    if (this == Level.FINE) return '👌';
    if (this == Level.CONFIG) return '🔧';
    if (this == Level.INFO) return '📝';
    if (this == Level.WARNING) return '📣';
    if (this == Level.SEVERE) return '🚨';
    if (this == Level.SHOUT) return '☠️ ';

    return '🤷‍♂️';
  }

  ConsoleColor get color {
    if (this == Level.FINEST) return ConsoleColor.green.highlight.bold;
    if (this == Level.FINER) return ConsoleColor.cyan.highlight.bold;
    if (this == Level.FINE) return ConsoleColor.blue.bold;
    if (this == Level.CONFIG) return ConsoleColor.gray;
    if (this == Level.INFO) return ConsoleColor.blue;
    if (this == Level.WARNING) return ConsoleColor.yellow.highlight;
    if (this == Level.SEVERE) return ConsoleColor.red.highlight.bold;
    if (this == Level.SHOUT) return ConsoleColor.magenta.highlight.bold;

    return ConsoleColor.none;
  }
}