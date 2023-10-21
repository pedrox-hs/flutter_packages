// ignore_for_file: implementation_imports

library auto_route_generator;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:auto_route/src/auto_route.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

import 'src/definitions.dart';
import 'src/utils.dart';

/// A [Builder] which generates a `.router.dart` file for each input `.dart`
///
/// builder_factories: ["RouteDefinitionsBuilder.create"]
class RouteDefinitionsBuilder extends Builder {
  RouteDefinitionsBuilder._([this.options = BuilderOptions.empty]);

  final BuilderOptions options;

  /// Create a [Builder] for [options].
  static Builder create([BuilderOptions options = BuilderOptions.empty]) =>
      RouteDefinitionsBuilder._(options);

  @override
  late final Map<String, List<String>> buildExtensions = {
    '.dart': ['.router.dart'],
  };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    log.info('buildStep.inputId: ${buildStep.inputId}');
    if (!await buildStep.resolver.isLibrary(buildStep.inputId)) return;

    final lib = await buildStep.resolver.libraryFor(
      buildStep.inputId,
      allowSyntaxErrors: false,
    );

    final definitions = findDefinitions(lib);
    await writeDefinitionsToFile(buildStep.inputId, definitions);
  }
}

// region: Pending implementations

Future<void> writeDefinitionsToFile(
  AssetId asset,
  List<FactoryDefinition> definitions,
) async {
  // TODO: implement
}

void printel(ClassElement element) {
  log.info('ClassElement{displayName: ${element.displayName}}');

  element.constructors
      .where((element) => isAutoRoutedChecker.hasAnnotationOf(element))
      .forEach(coisa);
}

void coisa(ConstructorElement e) {
  log.info('ConstructorElement{displayName: ${e.displayName}}');
  final annotation = isAutoRoutedChecker.firstAnnotationOf(e)!;
  final path = annotation.getField('path')?.toStringValue();
  final type = (annotation.type as ParameterizedType).typeArguments.firstWhere(
        (element) =>
            element.element != null &&
            isRouteChecker.isAssignableFrom(element.element!),
      );

  final constructors = (type.element as ClassElement).constructors;

  final opa = constructors.map(getRouteFactoryInfo).firstOrNull;

  log.info(
    'AutoRoute{path: $path, type: $type, args: $opa}}',
  );
}

RouteFactoryInfo getRouteFactoryInfo(ExecutableElement element) {
  final parameters = element.parameters.where(isParameterAllowed);

  return RouteFactoryInfo(
    path: 'todo',
    routeFactory: element,
    factoryParameters: parameters.toList(),
  );
}

bool isParameterAllowed(ParameterElement element) {
  try {
    if (canBeProvidedToRoute(element)) {
      return true;
    }
    if (element.isRequired) {
      throw Exception(
        'Unexpected required parameter: ${element.type} ${element.name}',
      );
    }
  } catch (e, stackTrace) {
    log.severe('Error while processing parameter: $element', e, stackTrace);
    rethrow;
  }
  return false;
}

const isAutoRoutedChecker = TypeChecker.fromRuntime(AutoRoute);

const isBuildContextChecker = TypeChecker.fromUrl(
  'package:flutter/src/widgets/framework.dart#BuildContext',
);

const isWidgetChecker = TypeChecker.fromUrl(
  'package:flutter/src/widgets/framework.dart#Widget',
);

const isWidgetBuilderChecker = TypeChecker.fromUrl(
  'package:flutter/src/widgets/framework.dart#WidgetBuilder',
);

const isRouteChecker =
    TypeChecker.fromUrl('package:flutter/src/widgets/navigator.dart#Route');

const isRouteSettingsChecker = TypeChecker.fromUrl(
  'package:flutter/src/widgets/navigator.dart#RouteSettings',
);

const isRouteExtrasChecker = TypeChecker.fromUrl(
  'package:simple_nav/src/route_resolver.dart#RouteExtras',
);

const isRouteFactoryChecker = TypeChecker.any(
  [
    isWidgetBuilderChecker,
    isRouteExtrasChecker,
    isRouteSettingsChecker,
  ],
);

bool isWidgetBuilder(ParameterElement element) {
  final type = element.type;

  return element.name == 'builder' &&
      type is FunctionType &&
      isWidgetChecker.isAssignableFromType(type.returnType) &&
      type.parameters.length == 1 &&
      type.parameters.first.isPositional &&
      isBuildContextChecker.isAssignableFromType(type.parameters.first.type);
}

bool isRouteSettings(ParameterElement element) {
  if (element.type.element == null) {
    return false;
  }
  return isRouteSettingsChecker.isAssignableFromType(element.type);
}

bool isRouteExtras(ParameterElement element) {
  if (element.type.element == null) {
    return false;
  }
  return isRouteExtrasChecker.isAssignableFromType(element.type);
}

bool canBeProvidedToRoute(ParameterElement element) {
  return isWidgetBuilder(element) ||
      isRouteExtras(element) ||
      isRouteSettings(element);
}
