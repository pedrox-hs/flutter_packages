import 'package:flutter/widgets.dart';

typedef RouteBuilder = Route Function(
  RouteSettings settings,
  RouteExtras extras,
);

class RouteResolver {
  RouteResolver(this.routes);

  final Map<String, RouteBuilder> routes;

  Route<dynamic>? call(RouteSettings settings) {
    final result = _findRoute(settings.name!);
    if (result == null) return null;

    final extras = RouteExtras(
      pathParameters: result.pathParameters,
      queryParameters: result.queryParameters,
      data: settings.arguments,
    );

    return result.routeBuilder(settings, extras);
  }

  PageBuilderResult? _findRoute(String routeName) {
    final uri = Uri.parse(routeName);

    if (routes.containsKey(uri.path)) {
      return PageBuilderResult(
        routes[uri.path]!,
        queryParameters: uri.queryParameters,
      );
    }

    for (final String route in routes.keys) {
      if (!route.contains(':')) continue;

      final expr = route.replaceAllMapped(
        RegExp(':([^/]+)'),
        (m) => '(?<${m[1]}>[^/]+)',
      );
      final match = RegExp(expr).firstMatch(uri.path);
      if (match == null) continue;

      final arguments = {
        for (final key in match.groupNames) key: match.namedGroup(key)!,
      };

      return PageBuilderResult(
        routes[route]!,
        queryParameters: uri.queryParameters,
        pathParameters: arguments,
      );
    }

    return null;
  }
}

class PageBuilderResult {
  const PageBuilderResult(
    this.routeBuilder, {
    this.queryParameters = const {},
    this.pathParameters = const {},
  });

  final RouteBuilder routeBuilder;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
}

class RouteExtras {
  const RouteExtras({
    this.pathParameters = const {},
    this.queryParameters = const {},
    this.data,
  });

  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final Object? data;
}
