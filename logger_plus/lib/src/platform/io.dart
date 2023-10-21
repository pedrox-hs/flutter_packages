export '_multiplatform.dart'
    if (dart.library.html) '_web.dart'
    if (dart.library.mirrors) '_cmdline.dart';
export 'stdio.dart';
