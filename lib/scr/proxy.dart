import 'package:flutter/widgets.dart';
import 'extensions.dart';
import 'services.dart';

mixin ProxyServiceMixin<T> on Service {
  bool proxyUpdateShouldNotify(T? value);

  @override
  bool updateShouldNotify() => super.updateShouldNotify() || proxyUpdateShouldNotify(read<T>());

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    listen<T>();
  }
}

abstract class ProxyService<T> extends Service with ProxyServiceMixin<T>{
  ProxyService(super.widget);
  
  @override
  bool updateShouldNotify() => proxyUpdateShouldNotify(read<T>());
}