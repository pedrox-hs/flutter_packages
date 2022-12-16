import 'dart:io';

import 'package:devtools/devtools.dart';

void main(List<String> args) async {
  exit(await runner.run(args) ?? 0);
}
