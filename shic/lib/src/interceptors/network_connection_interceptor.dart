import 'dart:io';

import 'package:http/http.dart';

import '../interceptor.dart';
import '../network_info.dart';

typedef IsConnectivityError = bool Function(dynamic exception);

class NetworkConnectionException implements IOException {}

class NetworkConnectionInterceptor implements HttpInterceptor {
  NetworkConnectionInterceptor({
    INetworkInfo? networkInfo,
    IsConnectivityError? isConnectivityError,
  }) : _networkInfo = networkInfo ?? NetworkInfo(), // coverage:ignore-line
       _isConnectivityError =
           isConnectivityError ?? defaultIsConnectivityErrorChecker;

  final INetworkInfo _networkInfo;
  final IsConnectivityError _isConnectivityError;
  Future<bool> get isDisconnected async => !await _networkInfo.isConnected;

  @override
  Future<StreamedResponse> intercept(BaseRequest request, Next next) async {
    if (await isDisconnected) {
      throw NetworkConnectionException();
    }
    try {
      return await next(request);
    } catch (e) {
      if (_isConnectivityError(e) && await isDisconnected) {
        throw NetworkConnectionException();
      }
      rethrow;
    }
  }
}

bool defaultIsConnectivityErrorChecker(dynamic exception) =>
    exception is SocketException;
