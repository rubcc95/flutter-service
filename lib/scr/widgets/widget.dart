import 'package:flutter/widgets.dart';

import '../services/change_notifier.dart';
import '../services/future.dart';
import 'multi.dart';
import '../services/service.dart';
import '../services/stream.dart';

typedef CreateServiceCallback<T extends Service> = T Function(
    InheritedWidget widget);

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

  static ServiceWidget<StreamService<T>> stream<T>(Stream<T> stream,
          {required T initialValue}) =>
      ServiceWidget(
          init: (widget) => StreamService(widget,
              stream: stream, initialValue: initialValue));

  static ServiceWidget<FutureService<T>> future<T>(Future<T> future,
          {required T initialValue}) =>
      ServiceWidget(
          init: (widget) => FutureService(widget,
              future: future, initialValue: initialValue));

  static ServiceWidget<ChangeNotifierService<T>> changeNotifier<
          T extends ChangeNotifier>(T changeNotifier) =>
      ServiceWidget(
          init: (widget) =>
              ChangeNotifierService(widget, changeNotifier: changeNotifier));

  final Widget? maybeChild;
  final CreateServiceCallback<T> init;

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
