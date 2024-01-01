import 'dart:convert';

import 'package:http/http.dart';

extension ResponseExt on Response {
  dynamic get bodyJson => json.decode(body);
}

extension StreamedResponseExt on StreamedResponse {
  Future<String> get body => toResponse().then((value) => value.body);

  Future<dynamic> get bodyJson async => json.decode(await body);

  Future<Response> toResponse() => Response.fromStream(this);
}

extension FutureResponseExt on Future<Response> {
  Future<Out> mapJsonWith<In, Out>(Out Function(In) fn) =>
      then((response) => fn(response.bodyJson));
}
