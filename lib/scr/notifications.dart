import 'package:flutter/widgets.dart';
import 'package:service/scr/services.dart';

class ServiceNotification<T> extends Notification {
  const ServiceNotification();

  Type get type => T;
}

mixin NotifiableServiceMixin on Service, NotifiableElementMixin {
  bool _needsUpdate = false;

  void notify() {
    _needsUpdate = true;
    markNeedsBuild();
  }

  @override
  bool onNotification(Notification notification) {
    if (notification is ServiceNotification &&
        notification.type == handledType) {
      notify();
      return true;
    }
    return false;
  }

  @override
  bool updateShouldNotify() {
    if (super.updateShouldNotify() || _needsUpdate) {
      _needsUpdate = false;
      return true;
    }
    return false;
  }
}

class NotifiableService extends Service
    with NotifiableElementMixin, NotifiableServiceMixin {
  NotifiableService(super.widget);

  @override
  bool updateShouldNotify() {
    if (_needsUpdate) {
      _needsUpdate = false;
      return true;
    }
    return false;
  }
}
