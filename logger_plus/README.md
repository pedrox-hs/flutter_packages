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
  Log.f('fatal error message');
  Log.tag('custom tag').d('debug message');
}
```

This print something like:

<img src="demo/messages.png?raw=true&v=2" alt="messages preview" width="600"/>

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
        if (level.isError) {
            // send to service like crashlytics
        }
    }
}
```

### Show error stack trace

```dart
void main() async {
    try {
        throw 'an error';
    } catch (error, stack) {
        Log.e(error, stack);
    }
}
```

### Display `Future` errors

When you don't need to handle failure for an operation, for debug purposes or something else, you can use `catchErrorLogger` extension to display any throwed error with stacktrace:

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
