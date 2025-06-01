import 'dart:convert';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:pubspec_gen/src/package_info_builder.dart';
import 'package:test/test.dart';

void main() {
  group('PubspecGenBuilder', () {
    test('Generates pubspec_info.dart with basic fields', () async {
      await testBuilder(
        PackageInfoBuilder(
          BuilderOptions({
            'fields': [
              {'path': 'name'},
              {'path': 'version'},
              {'path': 'description'},
              {'path': 'repository.url'},
            ],
          }),
        ),
        {
          'my_package|pubspec.yaml': '''
name: my_package
version: 1.2.3
description: Example package
repository:
  url: https://github.com/example/my_package
''',
        },
        outputs: {
          'my_package|lib/generated/pubspec_info.dart': decodedMatches(
            allOf(
              contains('class PubspecInfo'),
              contains("static const String name = 'my_package';"),
              contains("static const String version = '1.2.3';"),
              contains("static const String description = 'Example package';"),
              contains(
                "static const String repositoryUrl = 'https://github.com/example/my_package';",
              ),
            ),
          ),
        },
      );
    });

    test('Uses default value when key is missing', () async {
      await testBuilder(
        PackageInfoBuilder(
          BuilderOptions({
            'fields': [
              {'path': 'version', 'default': '0.0.1'},
            ],
          }),
        ),
        {
          'my_package|pubspec.yaml': '''
name: my_package
''',
        },
        outputs: {
          'my_package|lib/generated/pubspec_info.dart': decodedMatches(
            allOf(
              contains('class PubspecInfo'),
              contains("static const String version = '0.0.1';"),
            ),
          ),
        },
      );
    });

    test('Uses custom name if provided', () async {
      await testBuilder(
        PackageInfoBuilder(
          BuilderOptions({
            'fields': [
              {'path': 'name', 'name': 'packageName'},
            ],
          }),
        ),
        {
          'my_package|pubspec.yaml': '''
name: my_package
''',
        },
        outputs: {
          'my_package|lib/generated/pubspec_info.dart': decodedMatches(
            allOf(
              contains('class PubspecInfo'),
              contains("static const String packageName = 'my_package';"),
            ),
          ),
        },
      );
    });
  });
}

/// Helper matcher for utf8-decoded output content.
Matcher decodedMatches(Matcher matcher) => isA<List<int>>().having(
  (b) => utf8.decode(b),
  'utf-8 decoded bytes',
  matcher,
);
