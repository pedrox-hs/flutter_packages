import 'package:args/args.dart' show ArgParser, ArgResults;

import '../core/action.dart';
import '../core/command.dart';
import '../ext/args.dart';
import 'actions/firebase_cli.dart';
import 'actions/firebase_login.dart';
import 'actions/flutterfire.dart';

const _projectId = 'firebase-project-id';
const _androidPackageName = 'android-package-name';
const _iosBundleId = 'ios-bundle-id';

class ProjectSetupCommand extends BaseCommand {
  @override
  String name = 'project-setup';

  @override
  String description = 'Configure application project';

  late final ArgOptions args = ArgOptions.from(argResults!);

  ProjectSetupCommand() {
    ArgOptions.to(argParser);
  }

  @override
  List<Action> actions() => [
        InstallFirebaseCliIfNeeded(),
        LoginToFirebaseIfNeeded(),
        RemoveOldConfigFiles(),
        FlutterFireConfigure(args),
      ];
}

class ArgOptions implements IFlutterFireConfig {
  @override
  final String projectId;
  @override
  final String androidPackageName;
  @override
  final String iosBundleId;

  ArgOptions({
    required this.projectId,
    required this.androidPackageName,
    required this.iosBundleId,
  });

  factory ArgOptions.from(ArgResults args) => ArgOptions(
        projectId: args[_projectId],
        androidPackageName: args[_androidPackageName],
        iosBundleId: args[_iosBundleId],
      );

  static void to(ArgParser parser) {
    parser
      ..addEnvOption(
        _projectId,
        envName: 'FIREBASE_PROJECT_ID',
        help: 'Firebase project ID',
      )
      ..addEnvOption(
        _androidPackageName,
        envName: 'ANDROID_PACKAGE_NAME',
        help: 'Android package name',
      )
      ..addEnvOption(
        _iosBundleId,
        envName: 'IOS_BUNDLE_ID',
        help: 'iOS bundle ID',
      );
  }
}
