# pubspec_gen

[![pub package](https://img.shields.io/pub/v/pubspec_gen.svg)](https://pub.dev/packages/pubspec_gen)

A Dart and Flutter builder that generates a Dart class containing information from `pubspec.yaml`.

This allows you to access information like package name, version, description, repository URL, and more directly from your Dart code.

---

## 🚀 Motivation

Keeping `pubspec.yaml` information accessible in code is useful for:

- Displaying app name, version, or description in UIs or logs.
- Avoiding hardcoding and duplication between `pubspec.yaml` and Dart code.
- Building widgets or commands that reflect package metadata.

---

## ✨ Installation

Add to your project's `pubspec.yaml`:

```yaml
dev_dependencies:
  pubspec_gen: ^<latest_version>
  build_runner: any
```

---

## 🔧 Configuration (optional)

You can customize which fields to generate by adding a `build.yaml` to your project:

```yaml
targets:
  $default:
    builders:
      pubspec_gen|pubspec_gen:
        options:
          fields:
            - path: name
            - path: version
            - path: description
            - path: repository.url
              name: repositoryUrl
              default: https://github.com/example/repository
```

### 🏗️ Field properties:

| Property  | Description                                                |
| ----------| -----------------------------------------------------------|
| `path`    | Path in YAML, supports nested (`repository.url`)           |
| `name`    | (optional) Name of the property in the generated class     |
| `default` | (optional) Default value if not found in pubspec.yaml      |

If `name` is not set, it defaults to the normalized camelCase from `path`.

---

## 🛠️ Usage

Run the builder:

```bash
dart run build_runner build
```

It generates:

```
lib/generated/pubspec_info.dart
```

Example usage:

```dart
import 'generated/pubspec_info.dart';

void main() {
  print('Package name: ${PubspecInfo.name}');
  print('Version: ${PubspecInfo.version}');
  print('Description: ${PubspecInfo.description}');
}
```

---

## 📜 Example of generated code

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: constant_identifier_names

/// Package information generated from pubspec.yaml
class PubspecInfo {
  const PubspecInfo._();

  static const String name = 'my_package';
  static const String version = '1.0.0';
  static const String description = 'My awesome package';
  static const String repositoryUrl = 'https://github.com/example/repository';
}
```

---

## 🔍 Full example

Check the [`example/`](./example) directory for a working example.

---

## 💡 Contributing

Contributions are welcome! If you find any issues or have ideas for improvements:

1. Open an issue.
2. Submit a pull request.
3. Feel free to suggest new features.

---

## 📝 License

This project is licensed under the BSD-3-Clause License - see the [LICENSE](LICENSE) file for details.
