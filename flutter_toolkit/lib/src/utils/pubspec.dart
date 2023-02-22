import 'dart:io';

import 'package:yaml/yaml.dart';

final pubspec = Pubspec();

class Pubspec {
  late final dynamic _data = _loadYaml('pubspec.yaml');

  dynamic operator [](String key) => _data[key];

  String get name => this['name'];
}

dynamic _loadYaml(String filename) {
  final fileContent = File(filename).readAsStringSync();
  return loadYaml(fileContent);
}
