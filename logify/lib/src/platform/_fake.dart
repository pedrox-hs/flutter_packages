const window = _Window();

class _Window {
  const _Window();

  final _Console console = const _Console();
}

class _Console {
  const _Console();

  void log(Object? arg) => throw UnimplementedError(); // coverage:ignore-line

  void error(Object? arg) => throw UnimplementedError(); // coverage:ignore-line
}
