Just another library for logging.

A little bit based on [OkHttp](https://square.github.io/okhttp/) library.

> this library is currently in WIP

## Features

- build on top of [http](https://pub.dev/packages/http) library
- use base url for requests to avoid pass full url in all http calls

## Getting started

Add dependency to project:

```bash
flutter pub add http_client_plus --git-url=https://github.com/pedrox-hs/flutter_packages --git-path=http_client_plus
```

## Usage

Basic usage:

```dart
// example/main.dart
import 'package:http/http.dart' as http;
import 'package:http_client_plus/http_client_plus.dart';

void main() {
    final http.Client httpClient = InterceptableClient.withDefaultInterceptors(baseUrl: 'https://api.example.com');
    // use httpClient
}
```
