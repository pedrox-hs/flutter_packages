import 'dart:io' show Platform;

import '../../core/action.dart';
import '../../ext/shell.dart';

class FlutterFireConfigure extends IAction {
  final IFlutterFireConfig config;

  FlutterFireConfigure(this.config);

  @override
  Future<void> call() => exec(
        '''
        ${Platform.executable} run flutterfire_cli:flutterfire configure -y \\
          --out=lib/firebase_options.dart \\
          --platforms=android,ios \\
          --project=${config.projectId} \\
          --android-package-name=${config.androidPackageName} \\
          --ios-bundle-id=${config.iosBundleId}
        ''',
      );
}

class RemoveOldConfigFiles extends IAction {
  @override
  Future<void> call() => exec(
        '''
        rm android/app/google-services.json \\
          ios/Runner/GoogleService-Info.plist \\
          ios/firebase_app_id_file.json \\
          lib/firebase_options.dart
        ''',
        throwOnError: false,
        verbose: false,
      );
}

abstract class IFlutterFireConfig {
  String get projectId;
  String get androidPackageName;
  String get iosBundleId;
}
