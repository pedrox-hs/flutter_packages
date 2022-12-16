import 'dart:io';

import 'package:dotenv/dotenv.dart' show DotEnv;
import 'package:path/path.dart' show join;

final env = DotEnv()..load(['.env.default', '.env']);

extension DotEnvExt on DotEnv {
  String get path => '${Platform.environment['PATH']}:$binDir';

  String get binDir => join(Platform.environment['HOME']!, '.local', 'bin');
}
