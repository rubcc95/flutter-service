import 'package:flutter/widgets.dart';
import 'notifications.dart';
import 'services.dart';
import 'widgets.dart';

extension ServiceBuildContextExtension on BuildContext {  
  T? read<T>() {
    final res = getElementForInheritedWidgetOfExactType<ServiceWidget<T>>();
    return res == null
        ? null
        : res is T
            ? res as T
            : (res as ValueService<T>).value;
  }

  void listen<T>() => dependOnInheritedWidgetOfExactType<ServiceWidget<T>>();

  T? watch<T>(){
    listen<T>();
    return read<T>();
  }

  void notify<T>(){
    const ServiceNotification<T> notification = ServiceNotification();
    return notification.dispatch(this);
  }
}