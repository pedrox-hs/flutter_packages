[![codecov](https://codecov.io/gh/pedrox-hs/flutter_packages/graph/badge.svg?flag=logify)](https://codecov.io/gh/pedrox-hs/flutter_packages)
[![pub package](https://img.shields.io/pub/v/logify.svg)](https://pub.dev/packages/logify)
[![package publisher](https://img.shields.io/pub/publisher/logify.svg)](https://pub.dev/packages/logify/publisher)

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
dart pub add logify
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

<img src="https://github.com/pedrox-hs/flutter_packages/raw/main/logify/demo/simple.png?raw=true&v=1" alt="ConsoleLogRecorder output preview" width="600"/>

**DebugLogRecorder**

```dart
Log.listen(DebugLogRecorder());
```
Output:

<img src="https://github.com/pedrox-hs/flutter_packages/raw/main/logify/demo/colored.png?raw=true&v=2" alt="DebugLogRecorder output preview" width="600"/>
