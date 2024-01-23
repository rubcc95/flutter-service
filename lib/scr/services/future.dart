import 'package:flutter/widgets.dart';
import 'service.dart';
import 'stream.dart';
import 'subscription.dart';

class FutureService<T> extends SubscriptableService {
  T? _value;
  final Future<T> _future;
  ServiceStreamState _state = ServiceStreamState.waiting;

  FutureService(super.widget, {required Future<T> future, T? initialValue})
      : _future = future,
        _value = initialValue;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    addFuture<T>(_future, onData: (data) {
      _state = ServiceStreamState.active;
      _value = data;
      notify();
    });
  }

  T? get value => _value;
  ServiceStreamState get state => _state;
}

extension FutureServiceBuildContextExtension on BuildContext {
  StreamService<T> readFuture<T>() => read();
  void listenFuture<T>() => listen<StreamService<T>>();
}
