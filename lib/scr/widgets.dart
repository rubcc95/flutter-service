import 'package:flutter/widgets.dart';
import 'service.dart';

class _ValueStreamService<T> = StreamService<T>
    with DeferredValueServiceMixin<T?>;

class ServiceWidget<T extends Service> extends Widget
    implements InheritedWidget {
  const ServiceWidget({
    super.key,
    required this.init,
    Widget? child,
  }) : maybeChild = child;

  static Widget multi(
          {required List<ServiceWidget> services, required Widget child}) =>
      MultiServiceWidget(services: services, child: child);

  final Widget? maybeChild;
  final T Function(Widget widget) init;

  @override
  Widget get child {
    assert(maybeChild != null);
    return maybeChild!;
  }

  @override
  Service createElement() => init(this);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      throw StateError('Handled internally');

  ServiceWidget<T> _rebuild(Widget newChild) =>
      ServiceWidget(key: key, init: init, child: newChild);
}

class MultiServiceWidget extends StatelessWidget {
  final List<ServiceWidget> services;
  final Widget child;

  const MultiServiceWidget(
      {super.key, required this.services, required this.child});

  @override
  Widget build(BuildContext context) {
    Widget res = child;
    for (var i = services.length; i > 0; --i) {
      res = services[i]._rebuild(res);
    }
    return res;
  }
}

typedef ServiceBuilder<T> = Widget Function(T? value);

class ServiceConsumer<T> extends StatelessWidget {
  const ServiceConsumer(this.builder, {super.key, this.condition});

  final ServiceBuilder<T> builder;
  final ServiceListenCondition<T>? condition;

  @override
  Widget build(BuildContext context) =>
      builder((context..listen<T>(condition)).read<T>());
}
