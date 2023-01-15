import 'package:flutter/material.dart';

typedef PageBuilder = Widget Function(
  BuildContext context,
  RouteExtras extras,
);

class RouteResolver {
  RouteResolver(this.routes);

  final Map<String, PageBuilder> routes;

  Route<dynamic>? call(RouteSettings settings) {
    final result = _findRoute(settings.name!);
    if (result == null) return null;

    final extras = RouteExtras(result.arguments, settings.arguments);
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => result.pageBuilder(context, extras),
    );
  }

  PageBuilderResult? _findRoute(String routeName) {
    final uri = Uri.parse(routeName);

    if (routes.containsKey(uri.path)) {
      return PageBuilderResult(routes[uri.path]!, {...uri.queryParameters});
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
        for (final key in match.groupNames) key: match.namedGroup(key)
      };

      return PageBuilderResult(
        routes[route]!,
        {...uri.queryParameters, ...arguments},
      );
    }

    return null;
  }
}

class PageBuilderResult {
  PageBuilderResult(this.pageBuilder, [this.arguments = const {}]);

  final PageBuilder pageBuilder;
  final Map<String, dynamic> arguments;
}

class RouteExtras {
  RouteExtras(this.arguments, this.data);

  final Map<String, dynamic> arguments;
  final dynamic data;
}
