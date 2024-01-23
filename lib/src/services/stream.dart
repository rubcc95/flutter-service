import 'package:flutter/widgets.dart';

import 'service.dart';
import 'subscription.dart';

enum ServiceStreamState { waiting, active, done }

class StreamService<T> extends SubscriptableService {
  T? _value;
  final Stream<T> _stream;
  ServiceStreamState _state = ServiceStreamState.waiting;

  StreamService(super.widget, {required Stream<T> stream, T? initialValue})
      : _stream = stream,
        _value = initialValue;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    addStream<T>(_stream, onData: (data) {
      _state = ServiceStreamState.active;
      _value = data;
      notify();
    }, onDone: () {
      _state = ServiceStreamState.done;
    });
  }

  T? get value => _value;
  ServiceStreamState get state => _state;
}

extension StreamServiceBuildContextExtension on BuildContext {
  StreamService<T> readStream<T>() => read();
  void listenStream<T>() => listen<StreamService<T>>();
}
