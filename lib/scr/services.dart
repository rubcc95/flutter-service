import 'package:flutter/widgets.dart';

import 'widgets.dart';

abstract class Service extends InheritedElement {
  Service(super.widget);

  bool updateShouldNotify() => false;

  Type get handledType => runtimeType;

  @override
  void updated(covariant ServiceWidget oldWidget) {
    if (updateShouldNotify()) {
      notifyClients(oldWidget);
    }
  }
}

class ValueService<T> extends Service {
  ValueService(super.widget, this.value);

  final T value;

  @override
  Type get handledType => T;
}
