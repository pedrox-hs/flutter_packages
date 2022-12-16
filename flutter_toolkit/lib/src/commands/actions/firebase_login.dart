import 'dart:convert' show jsonDecode;

import '../../core/action.dart';
import '../../utils/shell.dart';

class LoginToFirebaseIfNeeded extends GrantedAction {
  @override
  bool get shouldRun {
    final accounts = jsonDecode(execSync('firebase', ['login:list', '-j']));
    return accounts['result'] == null || accounts['result'].isEmpty;
  }

  @override
  void requestPermission() {
    p('Firebase CLI not authenticated! Sign in now? [Y/n]: ');
  }

  @override
  void onDenied() {
    p(
      'Aborting...\nPlease login to Firebase account and try again\n'
      'firebase login\n\n',
    );
  }

  @override
  Future<void> onAllowed() async {
    p('Login...\n');

    await exec('''
      firebase login --reauth --interactive
    ''');
  }
}
