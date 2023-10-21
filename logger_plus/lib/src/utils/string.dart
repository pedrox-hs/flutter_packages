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

  String format(List<dynamic> params) => formatWithMap(
        {for (var index = params.length; index-- > 0;) '$index': params[index]},
      );

  String formatWithMap(Map<String, dynamic> params) =>
      formatWith((key) => params[key]);

  String formatWith(Function(String key) provider) => replaceAllMapped(
        RegExp(r'{(.*?)}'),
        (match) => '${provider(match[1]!) ?? match.input}',
      );

  String formatWithParameterized(
    Function(String key, List<String> params) provider,
  ) =>
      formatWith((key) {
        final params = key.split('|');
        return provider(params.first, params.skip(1).toList());
      });
}
