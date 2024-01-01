import 'package:flutter/services.dart' show AssetBundle, rootBundle;
import 'package:http/http.dart';

import '../interceptor.dart';

class AssetsInterceptor implements HttpInterceptor {
  AssetsInterceptor({
    this.assetsRootPath = 'assets',
    this.assetsScheme = 'assets',
    AssetBundle? bundle,
  }) : _bundle = bundle;

  final String assetsRootPath;
  final String assetsScheme;

  final AssetBundle? _bundle;
  late final AssetBundle _assetBundle = _bundle ?? rootBundle;

  @override
  Future<StreamedResponse> intercept(BaseRequest request, Next next) async {
    final url = request.url;
    if (!url.isScheme(assetsScheme)) {
      return next(request);
    }

    final path = url.toString().replaceFirst('$assetsScheme:/', assetsRootPath);
    final data = await _assetBundle.load(path);
    final intData =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    return StreamedResponse(
      ByteStream.fromBytes(intData),
      200,
      request: request,
      persistentConnection: false,
    );
  }
}
