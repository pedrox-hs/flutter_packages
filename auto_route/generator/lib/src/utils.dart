import 'package:analyzer/dart/element/element.dart';
import 'package:auto_route/auto_route.dart';
import 'package:source_gen/source_gen.dart';

import 'definitions.dart';

List<FactoryDefinition> findDefinitions(LibraryElement lib) {
  findAnnotatedElements<AutoRoute>(lib);
  return [];
}

/// Returns a list of [Element]s annotated with [T].
List<Element> findAnnotatedElements<T extends Object>(LibraryElement lib) {
  final checker = TypeChecker.fromRuntime(T);

  /// Returns `true` if [element] is annotated with [T].
  bool isMethodAnnotated(ExecutableElement element) =>
      checker.hasAnnotationOf(element);

  /// Returns `true` if [classElement] is annotated with [T].
  bool isClassAnnotated(ClassElement classElement) =>
      checker.hasAnnotationOf(classElement) ||
      classElement.constructors.any(isMethodAnnotated) ||
      classElement.methods.any(isMethodAnnotated);

  /// find annotated classes
  final clazz =
      lib.topLevelElements.whereType<ClassElement>().where(isClassAnnotated);

  /// find annotated functions
  final fn = lib.topLevelElements
      .whereType<FunctionElement>()
      .where(isMethodAnnotated);

  /// aggegate and return
  return List.from([...clazz, ...fn]);
}
