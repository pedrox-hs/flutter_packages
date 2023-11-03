# Logify

[![codecov](https://codecov.io/gh/pedrox-hs/flutter_packages/graph/badge.svg?flags=logify)](https://codecov.io/gh/pedrox-hs/flutter_packages)

Just another library for logging.

A little bit based on [Timber](https://github.com/JakeWharton/timber) library.

> Unfortunately, colors does not work for iPhone devices, so it is disabled only for iOS.

## Features

- show logs friendly using tags with call location, colors and emoji;
- open to implement your custom log output;
- written on top of [logging](https://pub.dev/packages/logging) library.

## Getting started

Add dependency to project:

```bash
flutter pub add logify --git-url=https://github.com/pedrox-hs/flutter_packages --git-path=logify
```

## Usage

```dart
// Import the package
import 'package:logify/logify.dart';

void main() {
  // In the main file or entrypoint add a recorder just once
  Log.listen(ConsoleLogRecorder());

  // Now, you can start using
  Log.i('info message');
}
```

You can also integrate with logging library:

```dart
import 'package:logify/logify.dart';
import 'package:logging/logging.dart';

void main() {
  // Change the logging level
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  // Add a recorder
  Logger.root.onRecord.listen(DebugLogRecorder());

  // Now, you can start using
  Log.i('info message');

  // Or use the logging library
  final logger = Logger('my_logger');
  logger.info('info message');
}
```
All other packages that use logging will also be handled by `DebugLogRecorder`.

For more details, see the [example](example) project and the logging library [documentation](https://pub.dev/packages/logging).


### `LogRecorder`


**ConsoleLogRecorder**

```dart
Log.listen(ConsoleLogRecorder());
```

Output:

<img src="demo/simple.png?raw=true&v=1" alt="messages preview" width="600"/>

**DebugLogRecorder**

```dart
Log.listen(DebugLogRecorder());
```
Output:

<img src="demo/colored.png?raw=true&v=2" alt="messages preview" width="600"/>
