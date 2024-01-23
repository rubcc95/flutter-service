import 'package:flutter/widgets.dart';
import 'widgets.dart';

typedef ServiceListenCondition<T extends Service> = bool Function(T service);

typedef _InternalServiceListenCondition = bool Function(Service service);

class ServiceNotification<T extends Service> extends Notification {
  const ServiceNotification();  

  Type get type => T;
}

abstract class Service extends InheritedElement with NotifiableElementMixin {
  Service(super.widget);
  Type get handledType => runtimeType;

  @override
  void updated(covariant ServiceWidget oldWidget) {
    if (updateShouldNotify()) {
      notifyClients(oldWidget);
    }
  }

  @override
  void notifyDependent(covariant InheritedWidget oldWidget, Element dependent) {
    final condition =
        getDependencies(dependent) as _InternalServiceListenCondition?;
    if (condition == null || condition(this) == true) {
      dependent.didChangeDependencies();
    }
  }

  bool _needsUpdate = false;

  void notify() {
    _needsUpdate = true;
    markNeedsBuild();
  }

  @override
  bool onNotification(Notification notification) {
    if (notification is ServiceNotification &&
        notification.type == runtimeType) {
      notify();
      return true;
    }
    return false;
  }

  bool updateShouldNotify() {
    if (_needsUpdate) {
      _needsUpdate = false;
      return true;
    }
    return false;
  }
}

extension ServiceBuildContextExtension on BuildContext {
  T read<T extends Service>() {
    final res = getElementForInheritedWidgetOfExactType<ServiceWidget<T>>();
    if (res == null) {
      throw StateError(
          '${ServiceWidget<T>} instance has never been included on the widget tree');
    }
    return res as T;
  }

  void listen<T extends Service>([ServiceListenCondition<T>? condition]) => dependOnInheritedWidgetOfExactType<ServiceWidget<T>>(aspect: condition == null ? null : (Service service) => condition(service as T));  

  void notify<T extends Service>() {
    const ServiceNotification<T> notification = ServiceNotification();
    return notification.dispatch(this);
  }
}