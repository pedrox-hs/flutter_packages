import '../../core/action.dart';
import '../../env.dart';
import '../../ext/shell.dart';

class InstallFirebaseCliIfNeeded extends GrantedAction {
  @override
  bool get shouldRun => !hasCommand('firebase');

  @override
  void requestPermission() {
    p('Firebase CLI command not found! Install it now? [Y/n]: ');
  }

  @override
  void onDenied() {
    p(
      'Aborting...\nPlease install manually and try again\n'
      'Instructions: https://firebase.google.com/docs/cli\n\n',
    );
  }

  @override
  Future<void> onAllowed() async {
    p('Installing...\n');

    final installDir = env.binDir.replaceAll('/', '\\/');

    await exec('''
      bash -c 'curl -sL https://firebase.tools \\
        | sed "s/INSTALL_DIR=.*/INSTALL_DIR=$installDir/; s/sudo//" \\
        | bash'
    ''');
  }
}
