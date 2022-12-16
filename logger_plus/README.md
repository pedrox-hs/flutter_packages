Just another library for logging.

A little bit based on [Timber](https://github.com/JakeWharton/timber) library.

> Unfortunately, colors does not work for iPhone devices, so it is disabled only for iOS.

## Features

- show logs friendly using tags with call location, colors and emoji;
- open to implement your custom log output;
- debug `Future` errors easily.

## Getting started

Add dependency to project:

```bash
flutter pub add logger_plus --git-url=https://github.com/pedrox-hs/flutter_packages --git-path=logger_plus
```

## Usage

Basic usage:

```dart
// example/main.dart
import 'package:logger_plus/logger_plus.dart';

void main() {
  Log.d('debug message');
  Log.i('info message');
  Log.wtf('wtf message');
  Log.w('warn message');
  Log.e('error message');
}
```

This print something like:

![messages](demo/messages.png?raw=true)

### Use custom `Tree` implementation

Alternatively, you can use a custom `Tree`, useful when you need to send errors to an external service:

```dart
import 'package:flutter/foundation.dart';
import 'package:logger_plus/logger_plus.dart';

void main() {
    if (kDebugMode) {
        Log.plant(DebugTree());
    } else {
        Log.plant(ErrorReporting());
    }
    Log.e('errors happens');
}

class ErrorReporting extends Tree {
    @override
    void log(Level level, String tag, dynamic message, [StackTrace? stackTrace]) {
        if (level == Level.error) {
            // send to service like crashlytics
        }
    }
}
```

### Handle `Future` errors

```dart
import 'package:logger_plus/logger_plus.dart';

void main() async {
    await runWithError()
        .catchError(catchErrorLogger);
}

Future<void> runWithError() async {
    throw 'error';
}
```
