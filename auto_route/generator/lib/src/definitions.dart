
import 'package:analyzer/dart/element/element.dart';

class FactoryDefinition {
  const FactoryDefinition({
    required this.route,
    required this.widget,
  });

  final RouteFactoryInfo route;
  final WidgetFactoryInfo widget;

  @override
  String toString() => 'FactoryDefinition{route: $route, widget: $widget}';
}

class RouteFactoryInfo {
  const RouteFactoryInfo({
    required this.path,
    required this.routeFactory,
    required this.factoryParameters,
  });

  final String path;
  final ExecutableElement routeFactory;
  final List<ParameterElement> factoryParameters;

  @override
  String toString() =>
      'RouteFactoryInfo{path: $path, routeFactory: ${routeFactory.displayName}, factoryParameters: $factoryParameters}';
}

class WidgetFactoryInfo {
  const WidgetFactoryInfo({
    required this.routeFactory,
    required this.factoryParameters,
  });

  final ExecutableElement routeFactory;
  final List<ParameterElement> factoryParameters;

  @override
  String toString() =>
      'WidgetFactoryInfo{routeFactory: ${routeFactory.displayName}, factoryParameters: $factoryParameters}';
}