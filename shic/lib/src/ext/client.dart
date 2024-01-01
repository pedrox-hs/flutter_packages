import 'package:http/http.dart';

extension ClientExt on Client {
  Future<Response> upload(
    Uri url,
    Iterable<MultipartFile> files, {
    String method = 'POST',
    Map<String, String> fields = const <String, String>{},
  }) async {
    final request = MultipartRequest(method, url)
      ..files.addAll(files)
      ..fields.addAll(fields);

    return Response.fromStream(await send(request));
  }
}
