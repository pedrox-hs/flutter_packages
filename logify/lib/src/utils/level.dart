import 'package:logging/logging.dart';

import 'color.dart';

extension LevelExt on Level {
  String get emoji => _styles[this]?.emoji ?? '🤷‍♂️';

  ConsoleColor get color => _styles[this]?.color ?? const ConsoleColor.none();
}

final _styles = <Level, _Style>{
  Level.FINEST: const _Style('🔬', ConsoleColor.gray()),
  Level.FINER: const _Style('🔎', ConsoleColor.cyan()),
  Level.FINE: _Style('👌', const ConsoleColor.green().highlighted.bold),
  Level.CONFIG: _Style('🔧', const ConsoleColor.gray().highlighted),
  Level.INFO: _Style('📝', const ConsoleColor.blue().bold),
  Level.WARNING: _Style('📣', const ConsoleColor.yellow().highlighted),
  Level.SEVERE: _Style('🚨', const ConsoleColor.red().highlighted.bold),
  Level.SHOUT: _Style('☠️ ', const ConsoleColor.magenta().highlighted.bold),
};

class _Style {
  const _Style(this.emoji, this.color);

  final String emoji;
  final ConsoleColor color;
}
