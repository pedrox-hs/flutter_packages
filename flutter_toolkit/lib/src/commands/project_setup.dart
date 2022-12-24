import 'package:args/args.dart' show ArgParser, ArgResults;

import '../core/command.dart';
import '../utils/args.dart';
import 'actions/firebase_cli.dart';
import 'actions/firebase_login.dart';
import 'actions/flutterfire.dart';

const _projectId = 'firebase-project-id';
const _androidPackageName = 'android-package-name';
const _iosBundleId = 'ios-bundle-id';
const _platforms = 'platforms';

class ProjectSetupCommand extends BaseCommand<IFlutterFireConfig> {
  ProjectSetupCommand()
      : super(
          name: 'project-setup',
          description: 'Configure application project',
          adapter: _Adapter(),
        );

  @override
  List<Action> actions() => [
        InstallFirebaseCliIfNeeded(),
        LoginToFirebaseIfNeeded(),
        RemoveOldConfigFiles(),
        FlutterFireConfigure(args),
        RemoveUnusedClientInfo(androidPackageName: args.androidPackageName),
      ];
}

class _ArgOptions implements IFlutterFireConfig {
  @override
  final String projectId;
  @override
  final String androidPackageName;
  @override
  final String iosBundleId;
  @override
  final List<String> platforms;

  _ArgOptions({
    required this.projectId,
    required this.androidPackageName,
    required this.iosBundleId,
    required this.platforms,
  });

  factory _ArgOptions.from(ArgResults args) => _ArgOptions(
        projectId: args[_projectId],
        androidPackageName: args[_androidPackageName],
        iosBundleId: args[_iosBundleId],
        platforms: args[_platforms],
      );
}

class _Adapter extends IArgParserAdapter<IFlutterFireConfig> {
  @override
  ArgParser parser(ArgParser parser) => parser
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
    )
    ..addMultiOption(
      _platforms,
      defaultsTo: ['android', 'ios'],
      help: 'Enabled platforms',
    );

  @override
  IFlutterFireConfig fromResults(ArgResults results) =>
      _ArgOptions.from(results);
}
