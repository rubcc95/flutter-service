import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'change_notifier.dart';
import 'future.dart';
import 'multi_service.dart';
import 'service.dart';
import 'streams.dart';

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

typedef ConsumeServiceCallback<T extends Service> = Widget Function(T? value);

class ServiceConsumer<T extends Service> extends StatelessWidget {
  const ServiceConsumer(this.builder, {super.key, this.condition});

  final ConsumeServiceCallback<T> builder;
  final ServiceListenCondition<T>? condition;

  @override
  Widget build(BuildContext context) =>
      builder((context..listen<T>(condition)).read<T>());
}
