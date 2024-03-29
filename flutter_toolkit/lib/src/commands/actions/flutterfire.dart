import 'dart:convert';
import 'dart:io' show File, Platform;

import '../../core/action.dart';
import '../../utils/shell.dart';

class FlutterFireConfigure implements IAction {
  const FlutterFireConfigure(this.config);

  final IFlutterFireConfig config;

  @override
  Future<void> call() => exec(
        '''
        ${Platform.executable} run flutterfire_cli:flutterfire configure -y \\
          --out=lib/firebase_options.dart \\
          --platforms=${config.platforms.join(',')} \\
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

class RemoveUnusedClientInfo extends IAction {
  RemoveUnusedClientInfo({
    required this.androidPackageName,
  });

  late final File configFile = File('android/app/google-services.json');

  final String androidPackageName;

  @override
  Future<void> call() async {
    final configData = await configFile.readAsString();
    Map<String, dynamic> config = jsonDecode(configData);

    config['client'].removeWhere((el) {
      final clientInfo = el['client_info']['android_client_info'];
      return clientInfo['package_name'] != androidPackageName;
    });

    const encoder = JsonEncoder.withIndent('  ');
    await configFile.writeAsString(encoder.convert(config));
  }
}

abstract class IFlutterFireConfig {
  String get projectId;
  String get androidPackageName;
  String get iosBundleId;
  List<String> get platforms;
}
