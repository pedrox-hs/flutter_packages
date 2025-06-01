part of '../bloc.dart';

abstract class _StateBloc<S extends IState> extends _BlocBase
    implements _RealStateType<S> {
  _StateBloc(super.initialState) : _currentState = initialState;

  S _currentState;
  @override
  S get currentState => state is S ? state as S : _currentState;

  void setState(S newState) {
    _currentState = newState;
    emit(newState);
  }

  void setStateFrom(Stream<S> stream) =>
      stream.listen(setState).addTo(subscriptions);
}

abstract class _BlocBase extends Cubit {
  _BlocBase(super.initialState);

  @override
  @internal
  dynamic get state => super.state;

  bool _isLoadPending = true;

  @override
  Stream get stream {
    _loadIfNeeded();
    return super.stream;
  }

  @protected
  final subscriptions = CompositeSubscription();

  @protected
  @visibleForOverriding
  FutureOr<void> load() {}

  @override
  @internal
  void emit(state) => super.emit(state);

  @override
  Future<void> close() async {
    await subscriptions.dispose();
    return super.close();
  }

  void _loadIfNeeded() async {
    if (_isLoadPending) {
      _isLoadPending = false;
      load();
    }
  }
}

mixin _ActionBlocMixin<A extends IAction, S> on BlocBase
    implements _RealStateType<S> {
  void sendAction(A action) {
    // workaround to enable same action dispatch
    emit(action);
    emit(currentState);
  }
}

abstract class _RealStateType<S> {
  S get currentState;
}
