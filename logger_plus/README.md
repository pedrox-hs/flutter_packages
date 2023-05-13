Just another library for logging.

A little bit based on [Timber](https://github.com/JakeWharton/timber) library.

> Unfortunately, colors does not work for iPhone devices, so it is disabled only for iOS.

## Features

- show logs friendly using tags with call location, colors and emoji;
- open to implement your custom log output;
- written on top of [logging](https://pu) library.

## Getting started

Add dependency to project:

```bash
flutter pub add logger_plus --git-url=https://github.com/pedrox-hs/flutter_packages --git-path=logger_plus
```

## Usage

```dart
// Import the package
import 'package:logger_plus/logger_plus.dart';

// In the main file or entrypoint add a recorder
Log.listen(ConsoleLogRecorder());

// Now, you can start using
Log.d('debug message');
```

### `LogRecorder`


**ConsoleLogRecorder**

```dart
Log.listen(ConsoleLogRecorder());
```

Output:

<img src="demo/simple.png?raw=true&v=1" alt="messages preview" width="600"/>

**ConsoleLogRecorder**

```dart
Log.listen(DebugLogRecorder());
```
Output:

<img src="demo/colored.png?raw=true&v=1" alt="messages preview" width="600"/>

