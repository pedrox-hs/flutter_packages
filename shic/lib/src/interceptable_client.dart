import 'package:http/http.dart';

import 'client_wrapper.dart';
import 'interceptor.dart';
import 'interceptors/assets.dart';
import 'interceptors/base_url_resolver.dart';
import 'interceptors/connection.dart';

typedef ChainInterceptor = Future<StreamedResponse> Function(BaseRequest req);

class InterceptableClient extends BaseClient {
  InterceptableClient({
    required this.interceptors,
    Client? baseClient,
  }) : _client = ClientWrapper(baseClient ?? Client());

  factory InterceptableClient.withDefaultInterceptors({
    Uri? baseUrl,
    Client? baseClient,
    Iterable<HttpInterceptor> interceptors = const [],
  }) =>
      InterceptableClient(
        baseClient: baseClient,
        interceptors: [
          const AssetsInterceptor(),
          ConnectionInterceptor(),
          if (baseUrl != null) ResolveBaseUrlInterceptor(baseUrl),
          ...interceptors,
        ],
      );

  final ClientWrapper _client;
  final Iterable<HttpInterceptor> interceptors;

  ChainInterceptor get _chain =>
      interceptors.toList().reversed.fold(_client.call, _chainInterceptor);

  @override
  Future<StreamedResponse> send(BaseRequest request) => _chain.call(request);

  ChainInterceptor _chainInterceptor(chain, interceptor) {
    return (BaseRequest request) => interceptor.intercept(request, chain);
  }
}
