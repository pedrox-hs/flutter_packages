/// Uses ANSI escape codes to color the console.
/// Color value is based on the 8-color ANSI standard.
///
/// for more info see: https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
class ConsoleColor {
  const ConsoleColor._(
    this.value, {
    this.style = 0,
    this.isHighlighed = false,
  });

  factory ConsoleColor.black() => ConsoleColor._(0);
  factory ConsoleColor.red() => ConsoleColor._(1);
  factory ConsoleColor.green() => ConsoleColor._(2);
  factory ConsoleColor.yellow() => ConsoleColor._(3);
  factory ConsoleColor.blue() => ConsoleColor._(4);
  factory ConsoleColor.magenta() => ConsoleColor._(5);
  factory ConsoleColor.cyan() => ConsoleColor._(6);
  factory ConsoleColor.gray() => ConsoleColor._(7);

  /// Use this to reset the console color.
  factory ConsoleColor.defaults() = _ConsoleColorDefault;

  /// Use this to disable colors.
  factory ConsoleColor.none() = _ConsoleColorNone;

  final int value;
  final int style;
  final bool isHighlighed;

  /// The ANSI code of this console color.
  int get ansiCode => isHighlighed ? value + 90 : value + 30;

  ConsoleColor get normal => copyWith(style: 0);
  ConsoleColor get bold => copyWith(style: 1);

  ConsoleColor get light => copyWith(isHighlighed: false);
  ConsoleColor get highlighted => copyWith(isHighlighed: true);

  /// Wraps the [text] with this console color.
  String wrap(Object text) => '$this$text${ConsoleColor.defaults()}';

  /// Copies this console color with the given values.
  ConsoleColor copyWith({int? value, int? style, bool? isHighlighed}) {
    value ??= this.value;
    style ??= this.style;

    assert(value >= 0 && value <= 7);
    assert(style >= 0 && style <= 1);

    return ConsoleColor._(
      value,
      style: style,
      isHighlighed: isHighlighed ?? this.isHighlighed,
    );
  }

  /// Returns the ANSI escape code for this console color.
  @override
  String toString() => '\x1b[$style;${ansiCode}m';
}

/// The default console color.
class _ConsoleColorDefault implements ConsoleColor {
  const _ConsoleColorDefault();

  @override
  final int value = 0;
  @override
  final int style = 0;
  @override
  final bool isHighlighed = false;

  @override
  int get ansiCode => 0;

  @override
  ConsoleColor get normal => this;
  @override
  ConsoleColor get bold => this;

  @override
  ConsoleColor get light => this;
  @override
  ConsoleColor get highlighted => this;

  @override
  String wrap(Object text) => '$this$text$this';

  @override
  ConsoleColor copyWith({int? value, int? style, bool? isHighlighed}) => this;

  @override
  String toString() => '\x1b[0m';
}

/// A console color when ANSI escape codes are not supported.
class _ConsoleColorNone implements ConsoleColor {
  const _ConsoleColorNone();

  @override
  final int value = -1;
  @override
  final int style = 0;
  @override
  final bool isHighlighed = false;

  @override
  int get ansiCode => -1;

  @override
  ConsoleColor get normal => this;
  @override
  ConsoleColor get bold => this;

  @override
  ConsoleColor get light => this;
  @override
  ConsoleColor get highlighted => this;

  @override
  String wrap(Object text) => text.toString();

  @override
  ConsoleColor copyWith({int? value, int? style, bool? isHighlighed}) => this;

  @override
  String toString() => '';
}
