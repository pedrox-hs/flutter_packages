extension StringExt on String {
  /// Returns a string with the given [width] by padding it with [padding].
  /// If the string is already longer than [width], it is returned unchanged.
  /// If the padding cannot be evenly distributed on both sides, the right side
  /// gets the extra padding.
  ///
  /// Example:
  /// ```
  /// 'hello'.padBoth(10, '*');
  /// ```
  /// This will return `'**hello***'`.
  String padBoth(int width, [String padding = ' ']) {
    if (length >= width) return this;
    final padLen = width - length;
    final padRem = padLen % 2;
    return padding * (padLen ~/ 2) + this + padding * (padLen ~/ 2 + padRem);
  }

  /// Replace all occurrences of {index} with the corresponding parameter..
  ///
  /// Example:
  /// ```
  /// '{0} {2} {0}'.format(['foo', 'bar', 'baz', 'qux']);
  /// ```
  /// This will return `'foo baz foo'`.
  String format(List<dynamic> params) => formatWithMap(
        {for (var index = params.length; index-- > 0;) '$index': params[index]},
      );

  /// Replaces all occurrences of `{key}` with the value from [params] with the
  /// corresponding key.
  /// If [params] does not contain a value for a key, the original string is
  /// used.
  /// Example:
  /// ```
  /// 'hello {world}'.formatWithMap({'world': 'foo'});
  /// ```
  /// This will return `'hello foo'`.
  String formatWithMap(Map<String, dynamic> params) =>
      formatWith((key) => params[key]);

  /// Replaces all occurrences of `{key}` with the value returned by [provider].
  /// If [provider] returns `null`, the original string is used.
  String formatWith(Function(String key) provider) => replaceAllMapped(
        RegExp(r'{(.*?)}'),
        (match) => '${provider(match[1]!) ?? match.input}',
      );

  /// Replaces all occurrences of `{key|param1|param2|...}` with the value
  /// returned by [provider].
  /// If [provider] returns `null`, the original string is used.
  /// The parameters are passed as a list to [provider].
  /// Example:
  /// ```
  /// 'hello {0|world|foo|bar}'.formatWithParameterized((key, params) => params.join(', '));
  /// ```
  /// This will return `hello world, foo, bar`.
  String formatWithParameterized(
    Function(String key, List<String> params) provider,
  ) =>
      formatWith((key) {
        final params = key.split('|');
        return provider(params.first, params.skip(1).toList());
      });
}
