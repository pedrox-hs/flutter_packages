import 'package:http/http.dart';

extension RequestExt<T extends BaseRequest> on T {
  T copyWith({
    Uri? url,
    Map<String, String> headers = const {},
  }) {
    final original = this;
    late final dynamic newRequest;

    if (original is Request) {
      newRequest = Request(original.method, url ?? original.url)
        ..encoding = original.encoding
        ..bodyBytes = original.bodyBytes;
    } else if (original is MultipartRequest) {
      newRequest = MultipartRequest(original.method, url ?? original.url)
        ..fields.addAll(original.fields)
        ..files.addAll(original.files);
    } else if (original is StreamedRequest) {
      newRequest = StreamedRequest(original.method, url ?? original.url);
    } else {
      throw UnsupportedError('Unsupported request type `$runtimeType`');
    }

    return newRequest
      ..headers.addAll({...original.headers, ...headers})
      ..persistentConnection = original.persistentConnection
      ..followRedirects = original.followRedirects
      ..maxRedirects = original.maxRedirects;
  }
}
