import 'package:flutter/widgets.dart';
import 'package:service/scr/services.dart';

class ServiceWidget<T> extends InheritedWidget {
  const ServiceWidget({super.key, required super.child, required this.init});

  final T Function(ServiceWidget<T> widget) init;

  @override
  Service createElement() {
    final service = init(this);
    return service is Service ? service : ValueService<T>(this, service);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}