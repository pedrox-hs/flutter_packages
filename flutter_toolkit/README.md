A command tookilt for flutter projects.

> this plugin is currently in WIP and supports only UNIX based systems

## Features
- Easily download Firebase files for project;
- Retrieve environment variables using `--dart-define` format;
- Run app passing values from `.env` files as `--dart-define` arguments.

## Getting started

### Installation

Activate plugin:

```bash
dart pub global activate \
    -sgit https://github.com/pedrox-hs/flutter_packages.git \
    --git-path flutter_toolkit
```

> Dart command activation from Git repository has an issue [#3403](https://github.com/dart-lang/pub/issues/3403), if you have any throuble related to it, you should clone this repository locally:

```bash
git clone https://github.com/pedrox-hs/flutter_packages.git

dart pub global activate -spath flutter_packages/flutter_toolkit
```

Or add as dependency to project:

```bash
flutter pub add flutter_toolkit --dev \
    --git-url=https://github.com/pedrox-hs/flutter_packages \
    --git-path=flutter_toolkit
```
> If you choose to use as project dependency, consider use `dart run flutter_toolkit:cli` instead of `flutter_toolkit` command as described here

### Configuration (Recommended)

You can create `.env.default` (and `.env`) file with basic project variables:

```bash
# replace [project-id], [android-package] and [ios-bundle-id] with valid values
FIREBASE_PROJECT_ID=[project-id]
ANDROID_PACKAGE_NAME=[android-package]
IOS_BUNDLE_ID=[ios-bundle-id]
```

> When load, all values retrieved from `.env.default` will be replaced by values from `.env` file, and don't need to declare variable in both files if the value is not different.

Add `.env` to `.gitignore`:

```bash
echo '.env' >> .gitignore
```

## Usage

Run help command to show usages:

```bash
flutter_toolkit --help
```

### `project-setup`

In open source project when we using Firebase services, generally we not versioning the configuration files, but when some people needs to contribute, this files is required to build app, so to download Firebase configuration files run:

```bash
flutter_toolkit project-setup
```
This command will do:
- try to read `FIREBASE_PROJECT_ID`, `ANDROID_PACKAGE_NAME`  and `IOS_BUNDLE_ID` environment variables;
- Verify if `Firebase CLI` is available, if not it will try to install;
- Verify if `Firebase CLI` is authenticated, if not you will be asked to sign in.

### `run-app`

Run Flutter app passing `--dart-define` values from `.env` file:

```bash
flutter_toolkit run-app
```
> this command accept all `flutter run` arguments

### `dart-define`

Combine `dart-define` with `xargs` command, example:

```bash
flutter_toolkit dart-define | xargs flutter build apk
```

Alternatively, to simplify it you can define an alias for `flutter build` or any other command:

```bash
# ~/.bashrc
alias flutter_build='flutter_toolkit dart-define | xargs flutter build'
```
