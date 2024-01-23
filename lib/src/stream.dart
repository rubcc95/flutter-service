import 'package:flutter/widgets.dart';

import 'served.dart';
import 'subscriptor.dart';

enum ServedStreamState { waiting, active, done, error }

class ServedStream<T> extends ServedSubscriptor {
  T? _value;
  final Stream<T> _stream;
  ServedStreamState _state = ServedStreamState.waiting;
  Object? _error;
  StackTrace _stackTrace = StackTrace.empty;

  ServedStream(super.widget, {required Stream<T> stream, T? initialValue})
      : _stream = stream,
        _value = initialValue;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    addStream<T>(_stream, onData: (data) {
      _state = ServedStreamState.active;
      _value = data;
      notify();
    }, onDone: () {
      _state = ServedStreamState.done;
      _value = null;
      notify();
    }, onError: (error, stackTrace) {
      _state = ServedStreamState.error;
      _value = null;
      _error = error;
      _stackTrace = stackTrace;
      notify();
    });
  }

  T get value {
    assert(
        _value != null,
        'Stream has not emitted any value. '
        'Check for state == ${ServedStreamState.active} or set a not null value '
        'for initialValue on constructor before using this getter.');
    return _value!;
  }

  Object get error {
    assert(
        _value != null,
        'Stream has not emitted any error. '
        'Check for state == ${ServedStreamState.error} '
        'before using this getter.');
    return _error!;
  }

  StackTrace get stackTrace => _stackTrace;

  ServedStreamState get state => _state;
}

extension ServedStreamContext on BuildContext {
  ServedStream<T> readStream<T>() => read();

  void listenStream<T>() => listen<ServedStream<T>>();
}
