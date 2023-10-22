SHIC (Simple HTTP Interceptor Chain) is just another library for HTTP requests.

A little bit based on [OkHttp](https://square.github.io/okhttp/) library.

> this library is currently in WIP

## Features

- build on top of [http](https://pub.dev/packages/http) library
- use base url for requests to avoid pass full url in all http calls

## Getting started

Add dependency to project:

```bash
flutter pub add shic --git-url=https://github.com/pedrox-hs/flutter_packages --git-path=shic
```

## Usage

Basic usage:

```dart
// example/main.dart
import 'package:http/http.dart' as http;
import 'package:shic/shic.dart';

void main() {
    final http.Client httpClient = InterceptableClient.withDefaultInterceptors(
        baseUrl: 'https://api.example.com',
        interceptors: [
            // add custom interceptors
        ],
    );
    // use httpClient
}
```
