/// Uses ANSI escape codes to color the console.
/// Color value is based on the 8-color ANSI standard.
///
/// for more info see: https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
abstract class ConsoleColor {
  const ConsoleColor._();

  const factory ConsoleColor.black() = _ConsoleColorBlack;
  const factory ConsoleColor.red() = _ConsoleColorRed;
  const factory ConsoleColor.green() = _ConsoleColorGreen;
  const factory ConsoleColor.yellow() = _ConsoleColorYellow;
  const factory ConsoleColor.blue() = _ConsoleColorBlue;
  const factory ConsoleColor.magenta() = _ConsoleColorMagenta;
  const factory ConsoleColor.cyan() = _ConsoleColorCyan;
  const factory ConsoleColor.gray() = _ConsoleColorGray;

  /// Use this to disable colors.
  const factory ConsoleColor.none() = _ConsoleColorNone;

  ConsoleColor get normal;
  ConsoleColor get bold;

  ConsoleColor get light;
  ConsoleColor get highlighted;

  String wrap(Object text);
}

/// Default implementation of [ConsoleColor].
class _ConsoleColorBase implements ConsoleColor {
  const _ConsoleColorBase._({
    required this.value,
    required this.name,
    this.style = 0,
    this.isHighlighed = false,
  });

  final String name;
  final int value;
  final int style;
  final bool isHighlighed;

  /// The ANSI code of this console color.
  int get ansiCode => isHighlighed ? value + 90 : value + 30;

  @override
  ConsoleColor get normal => _copyWith(style: 0);
  @override
  ConsoleColor get bold => _copyWith(style: 1);

  @override
  ConsoleColor get light => _copyWith(isHighlighed: false);
  @override
  ConsoleColor get highlighted => _copyWith(isHighlighed: true);

  // Returns the ANSI escape code for this console color.
  String get startMarker => '\x1b[$style;${ansiCode}m';
  String get endMarker => '\x1b[0m';

  /// Wraps the [text] with this console color.
  @override
  String wrap(Object text) => '${startMarker}${text}${endMarker}';

  /// Copies this console color with the given values.
  ConsoleColor _copyWith({int? value, int? style, bool? isHighlighed}) {
    value ??= this.value;
    style ??= this.style;

    assert(value >= 0 && value <= 7);
    assert(style >= 0 && style <= 1);

    return _ConsoleColorBase._(
      value: value,
      name: name,
      style: style,
      isHighlighed: isHighlighed ?? this.isHighlighed,
    );
  }

  @override
  String toString() => name;
}

/// A console color when ANSI escape codes are not supported.
class _ConsoleColorNone extends ConsoleColor {
  const _ConsoleColorNone() : super._();

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
  String toString() => 'none';
}

class _ConsoleColorBlack extends _ConsoleColorBase {
  const _ConsoleColorBlack() : super._(name: 'black', value: 0);
}

class _ConsoleColorRed extends _ConsoleColorBase {
  const _ConsoleColorRed() : super._(name: 'red', value: 1);
}

class _ConsoleColorGreen extends _ConsoleColorBase {
  const _ConsoleColorGreen() : super._(name: 'green', value: 2);
}

class _ConsoleColorYellow extends _ConsoleColorBase {
  const _ConsoleColorYellow() : super._(name: 'yellow', value: 3);
}

class _ConsoleColorBlue extends _ConsoleColorBase {
  const _ConsoleColorBlue() : super._(name: 'blue', value: 4);
}

class _ConsoleColorMagenta extends _ConsoleColorBase {
  const _ConsoleColorMagenta() : super._(name: 'magenta', value: 5);
}

class _ConsoleColorCyan extends _ConsoleColorBase {
  const _ConsoleColorCyan() : super._(name: 'cyan', value: 6);
}

class _ConsoleColorGray extends _ConsoleColorBase {
  const _ConsoleColorGray() : super._(name: 'gray', value: 7);
}
