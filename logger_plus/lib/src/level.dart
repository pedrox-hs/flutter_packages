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
    if (this == Level.SHOUT) return '☠️';

    return '🤷‍♂️';
  }

  Color get color {
    if (this == Level.FINEST) return Color.green.highlight.bold;
    if (this == Level.FINER) return Color.cyan.highlight.bold;
    if (this == Level.FINE) return Color.blue.bold;
    if (this == Level.CONFIG) return Color.gray;
    if (this == Level.INFO) return Color.blue;
    if (this == Level.WARNING) return Color.yellow.highlight;
    if (this == Level.SEVERE) return Color.red.highlight.bold;
    if (this == Level.SHOUT) return Color.magenta.highlight.bold;

    return Color.none;
  }
}