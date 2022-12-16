import 'dart:io';

import 'package:dotenv/dotenv.dart' show DotEnv;
import 'package:path/path.dart' show join;

final Iterable<String> envFiles = [
  '.env.default',
  '.env',
].where((path) => File(path).existsSync());

final env = DotEnv()..load(envFiles);

extension DotEnvExt on DotEnv {
  String get path => '${Platform.environment['PATH']}:$binDir';

  String get binDir => join(Platform.environment['HOME']!, '.local', 'bin');

  // ignore: invalid_use_of_visible_for_testing_member
  Iterable<String> toDartDefine() => map.toDartDefine();
}

extension EnvMapExt on Map<String, String> {
  Iterable<String> toDartDefine() =>
      entries.map((e) => '--dart-define=\'${e.key}=${e.value}\'');
}
