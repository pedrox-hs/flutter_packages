import 'package:dotenv/dotenv.dart' show DotEnv;
import 'package:path/path.dart' show join;

final env = DotEnv(includePlatformEnvironment: true)
  ..load(['.env.default', '.env']);

extension DotEnvExt on DotEnv {
  String get path => '${this['PATH']}:$binDir';

  String get binDir => join(this['HOME']!, '.local', 'bin');
}
