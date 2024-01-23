import 'package:flutter/widgets.dart';

import 'multi.dart';
import '../services/change_notifier.dart';
import '../services/future.dart';
import '../services/value.dart';
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
  }) : _maybeChild = child;

  static Widget multi(
          {required List<ServiceWidget> services, required Widget child}) =>
      MultiServiceWidget(services: services, child: child);

  static ServiceWidget<StreamService<T>> stream<T>(Stream<T> stream,
          {T? initialValue}) =>
      ServiceWidget(
          init: (widget) => StreamService(widget,
              stream: stream, initialValue: initialValue));

  static ServiceWidget<FutureService<T>> future<T>(Future<T> future,
          {T? initialValue}) =>
      ServiceWidget(
          init: (widget) => FutureService(widget,
              future: future, initialValue: initialValue));

  static ServiceWidget<ChangeNotifierService<T>> changeNotifier<
          T extends ChangeNotifier>(T changeNotifier) =>
      ServiceWidget(
          init: (widget) =>
              ChangeNotifierService(widget, changeNotifier: changeNotifier));

  static ServiceWidget<ValueService<T>> value<T>(T value) =>
      ServiceWidget(init: (widget) => ValueService(widget, value: value));

  final Widget? _maybeChild;
  final CreateServiceCallback<T> init;

  @override
  Widget get child {
    assert(_maybeChild != null,
        '$ServiceWidget must have a child if is not nesed inside a ${ServiceWidget.multi} constructor');
    return _maybeChild!;
  }

  @override
  Service createElement() => init(this);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      throw StateError('Handled internally');
}
