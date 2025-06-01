class FieldConfig {
  FieldConfig({
    required this.path,
    required this.name,
    required this.defaultValue,
  });

  factory FieldConfig.fromMap(Map<String, dynamic> map) {
    final path = map['path'] as String;
    final name = (map['name'] as String?) ?? _normalizePath(path);
    final defaultValue = map.containsKey('default') ? map['default'] : '';

    return FieldConfig(path: path, name: name, defaultValue: defaultValue);
  }

  final String path;
  final String name;
  final dynamic defaultValue;

  static String _normalizePath(String path) {
    final parts = path.split(RegExp(r'[._-]'));
    final first = parts.first;
    final rest = parts.skip(1).map((e) => e[0].toUpperCase() + e.substring(1));
    return [first, ...rest].join();
  }

  @override
  String toString() =>
      'FieldConfig(path: "$path", name: "$name", defaultValue: "$defaultValue")';
}
