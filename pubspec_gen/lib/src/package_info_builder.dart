import 'dart:async';
import 'package:build/build.dart';
import 'package:yaml/yaml.dart';

import 'field_config.dart';

class PackageInfoBuilder implements Builder {
  PackageInfoBuilder(BuilderOptions options)
    : outputFile =
          options.config['output'] as String? ??
          'lib/generated/pubspec_info.dart',
      className = options.config['class_name'] as String? ?? 'PubspecInfo',
      header = options.config['header'] as String? ?? '',
      fields =
          ((options.config['fields'] ?? []) as List)
              .cast<Map>()
              .map((e) => FieldConfig.fromMap(e.cast()))
              .toList();

  final String outputFile;
  final String className;
  final String header;
  final List<FieldConfig> fields;

  @override
  Map<String, List<String>> get buildExtensions => {
    r'$package$': [outputFile],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = AssetId(buildStep.inputId.package, 'pubspec.yaml');
    if (!await buildStep.canRead(inputId)) {
      return log.severe('pubspec.yaml not found');
    }

    final yamlContent = loadYaml(await buildStep.readAsString(inputId));

    final buffer = StringBuffer();

    if (header.isNotEmpty) {
      buffer.writeln(header.replaceAll('\\n', '\n'));
    }

    buffer.writeln('''
/// Package information generated from pubspec.yaml
class $className {
  const $className._();
''');

    for (final field in fields) {
      final value =
          _extractValue(yamlContent, field.path) ?? field.defaultValue;
      final escapedValue = value.toString().replaceAll("'", "\\'");
      buffer.writeln("  static const String ${field.name} = '$escapedValue';");
    }

    buffer.writeln('}');

    final outputId = AssetId(buildStep.inputId.package, outputFile);

    await buildStep.writeAsString(outputId, buffer.toString());
  }

  dynamic _extractValue(dynamic yaml, String path) {
    final parts = path.split('.');
    dynamic current = yaml;
    for (final part in parts) {
      if (current is Map && current.containsKey(part)) {
        current = current[part];
      } else {
        return null;
      }
    }
    return current;
  }
}
