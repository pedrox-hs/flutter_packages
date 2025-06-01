import 'package:meta/meta.dart';

import 'converter.dart';

abstract class ErrorConverterRegistry {
  final _converters = <ErrorConverterWrapper>{};

  @protected
  @nonVirtual
  void on<T extends Object>(ErrorConverter converter) {
    assert(
      !_converters.any((handler) => handler.type == T),
      'on<$T> was called multiple times. '
      'There should only be a single error converter per error type.',
    );
    _converters.add(
      ErrorConverterWrapper(
        type: T,
        canConvert: (value) => value is T,
        convert: converter,
      ),
    );
  }

  bool hasConverterFor(Object error) =>
      _converters.any((el) => el.canConvert(error));

  ErrorConverter getConverterFor(Object error) =>
      _converters.firstWhere((el) => el.canConvert(error)).convert;

  ErrorConverterRegistryComposite operator +(ErrorConverterRegistry other) =>
      other is! ErrorConverterRegistryComposite
          ? ErrorConverterRegistryComposite([this, other])
          : other + this;
}

class ErrorConverterRegistryComposite extends ErrorConverterRegistry {
  ErrorConverterRegistryComposite(this._registries);

  final Iterable<ErrorConverterRegistry> _registries;

  @override
  bool hasConverterFor(Object error) =>
      _registries.any((el) => el.hasConverterFor(error));

  @override
  ErrorConverter getConverterFor(Object error) => _registries
      .firstWhere((el) => el.hasConverterFor(error))
      .getConverterFor(error);

  @override
  ErrorConverterRegistryComposite operator +(ErrorConverterRegistry other) =>
      ErrorConverterRegistryComposite([
        ..._registries,
        ...other is ErrorConverterRegistryComposite
            ? other._registries
            : [other],
      ]);
}
