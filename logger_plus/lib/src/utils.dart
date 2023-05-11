extension UriExt on Uri {
  /// Returns a normalized package URI.
  Uri normalizePackageUri() => scheme == 'package'
      ? replace(
          pathSegments: <String>[
            pathSegments.first,
            'lib',
            ...pathSegments.skip(1),
          ],
        )
      : this;
}

extension StringExt on String {
  /// Returns a string with the given [width] by padding it with [padding].
  /// If the string is already longer than [width], it is returned unchanged.
  /// If the padding cannot be evenly distributed on both sides, the right side
  /// gets the extra padding.
  /// 
  /// Example:
  /// ```
  /// 'hello'.padBoth(10, '*') == '***hello**'
  /// ```
  String padBoth(int width, [String padding = ' ']) {
    if (length >= width) return this;
    final padLen = width - length;
    final padRem = padLen % 2;
    return padding * (padLen ~/ 2) + this + padding * (padLen ~/ 2 + padRem);
  }
}
