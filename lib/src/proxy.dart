import 'package:flutter/widgets.dart';
import 'served.dart';

mixin ServedProxyMixin<S extends Served> on Served {
  bool proxyUpdateShouldNotify(S? value) => true;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    listen<S>(proxyUpdateShouldNotify);
  }
}

class ServedProxy<S extends Served> = Served with ServedProxyMixin<S>;
