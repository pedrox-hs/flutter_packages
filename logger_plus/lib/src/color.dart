/// for more info see: https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
class Color {
  Color._(
    this._value, {
    int style = 0,
    bool highligh = false,
  })  : _style = style,
        _highligh = highligh;

  static Color get none => Color._(-1);
  static Color get black => Color._(0);
  static Color get red => Color._(1);
  static Color get green => Color._(2);
  static Color get yellow => Color._(3);
  static Color get blue => Color._(4);
  static Color get magenta => Color._(5);
  static Color get cyan => Color._(6);
  static Color get gray => Color._(7);

  final int _value;
  final int _style;
  final bool _highligh;

  Color get normal => copyWith(style: 0);
  Color get bold => copyWith(style: 1);

  Color get highlight => copyWith(highligh: true);
  Color get light => copyWith(highligh: false);

  int get _code => _highligh ? _value + 90 : _value + 30;

  Color copyWith({int? value, int? style, bool? highligh}) {
    value ??= _value;
    style ??= _style;

    assert(value >= 0 && value <= 7);
    assert(style >= 0 && style <= 1);

    return Color._(value, style: style, highligh: highligh ?? _highligh);
  }

  @override
  String toString() => _value != -1 ? '\x1B[$_style;${_code}m' : '\x1B[0m';
}