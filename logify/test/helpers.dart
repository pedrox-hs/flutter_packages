import 'dart:math';
import 'dart:nativewrappers/_internal/vm/lib/mirrors_patch.dart'
    if (dart.library.mirrors) 'dart:mirrors';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

T invokeStaticMethod<T>(
  clazz,
  String methodName, [
  List positionalArgs = const [],
]) {
  final classMirror = reflectClass(clazz);
  final symbol = Symbol(methodName);

  final result = classMirror.invoke(symbol, positionalArgs);
  return result.reflectee as T;
}

T invokeInstanceMethod<T>(
  instance,
  String methodName, [
  List positionalArgs = const [],
]) {
  final instanceMirror = reflect(instance);
  final symbol = Symbol(methodName);

  final result = instanceMirror.invoke(symbol, positionalArgs);
  return result.reflectee as T;
}

T invokeInstanceGetter<T>(
  instance,
  String getterName,
) {
  final instanceMirror = reflect(instance);
  final symbol = Symbol(getterName);

  final field = instanceMirror.getField(symbol);
  return field.reflectee as T;
}

extension RandomExt on Random {
  String nextString(int length) => String.fromCharCodes(
    Iterable.generate(length, (_) => _chars.codeUnitAt(nextInt(_chars.length))),
  );
}
