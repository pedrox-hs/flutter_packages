import 'package:http/http.dart';
import 'package:meta/meta.dart';

@immutable
class ClientWrapper {
  const ClientWrapper(this.baseClient);

  final Client baseClient;

  Future<StreamedResponse> call(BaseRequest request) =>
      baseClient.send(request);
}
