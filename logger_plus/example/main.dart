// example/main.dart
import 'package:logger_plus/logger_plus.dart';

void main() {
  Log.d('debug message');
  Log.i('info message');
  Log.wtf('wtf message');
  Log.w('warn message');
  Log.e('error message');
  Log.f('fatal error message');
  Log.tag('custom tag').d('debug message');
}
