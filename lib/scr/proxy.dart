import 'package:flutter/widgets.dart';
import 'service.dart';

mixin ProxyServiceMixin<T extends Service> on Service{
  bool proxyUpdateShouldNotify(T? value) => true;

  @override
  void mount(Element? parent, Object? newSlot) {    
    super.mount(parent, newSlot);    
    listen<T>(proxyUpdateShouldNotify);
  }
}

class ProxyService<T extends Service> = Service with ProxyServiceMixin<T>;