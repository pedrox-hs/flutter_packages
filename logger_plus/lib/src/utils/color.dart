/// for more info see: https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
class ConsoleColor {
  const ConsoleColor._(
    this._value, {
    int style = 0,
    bool highligh = false,
  })  : _style = style,
        _highligh = highligh;

  static ConsoleColor get none => ConsoleColor._(-1);
  static ConsoleColor get black => ConsoleColor._(0);
  static ConsoleColor get red => ConsoleColor._(1);
  static ConsoleColor get green => ConsoleColor._(2);
  static ConsoleColor get yellow => ConsoleColor._(3);
  static ConsoleColor get blue => ConsoleColor._(4);
  static ConsoleColor get magenta => ConsoleColor._(5);
  static ConsoleColor get cyan => ConsoleColor._(6);
  static ConsoleColor get gray => ConsoleColor._(7);

  final int _value;
  final int _style;
  final bool _highligh;

  ConsoleColor get normal => copyWith(style: 0);
  ConsoleColor get bold => copyWith(style: 1);

  ConsoleColor get highlight => copyWith(highligh: true);
  ConsoleColor get light => copyWith(highligh: false);

  int get _code => _highligh ? _value + 90 : _value + 30;
  String get _codeStr => _value != -1 ? '\x1b[$_style;${_code}m' : '\x1b[0m';

  ConsoleColor copyWith({int? value, int? style, bool? highligh}) {
    value ??= _value;
    style ??= _style;

    assert(value >= 0 && value <= 7);
    assert(style >= 0 && style <= 1);

    return ConsoleColor._(value, style: style, highligh: highligh ?? _highligh);
  }

  @override
  String toString() => _codeStr;
}

extension ColoredStringExt on String {
  String colored(ConsoleColor color) =>
      color.toString() + this + ConsoleColor.none.toString();
}

extension ObjectColoredExt on Object {
  String toStringColored(ConsoleColor color) => toString().colored(color);
}
