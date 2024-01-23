import 'package:flutter/widgets.dart';
import 'served.dart';
import 'subscriptor.dart';

enum ServedFutureState { waiting, done, error }

class ServedFuture<T> extends ServedSubscriptor {
  T? _value;
  final Future<T> _future;
  ServedFutureState _state = ServedFutureState.waiting;
  Object? _error;
  StackTrace _stackTrace = StackTrace.empty;

  ServedFuture(super.widget, {required Future<T> future, T? initialValue})
      : _future = future,
        _value = initialValue;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    addFuture<T>(_future, onData: (data) {
      _state = ServedFutureState.done;
      _value = data;
      notify();
    }, onError: (error, stackTrace) {
      _state = ServedFutureState.error;
      _value = null;
      _error = error;
      _stackTrace = stackTrace;
      notify();
    });
  }

  T get value {
    assert(
        _value != null,
        'Future has not been completed. '
        'Check for state == ${ServedFutureState.done} or set a not null value '
        'for initialValue on constructor before using this getter.');
    return _value!;
  }

  Object get error {
    assert(
        _value != null,
        'Future has not emitted any error. '
        'Check for state == ${ServedFutureState.error} '
        'before using this getter.');
    return _error!;
  }

  StackTrace get stackTrace => _stackTrace;

  ServedFutureState get state => _state;
}

extension ServedFutureContext on BuildContext {
  ServedFuture<T> readFuture<T>() => read();

  void listenFuture<T>() => listen<ServedFuture<T>>();
}
