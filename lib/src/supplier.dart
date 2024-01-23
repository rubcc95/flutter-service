import 'package:flutter/widgets.dart';

import 'multi_server.dart';
import 'notifier.dart';
import 'future.dart';
import 'value.dart';
import 'served.dart';
import 'stream.dart';

typedef CreateServed<T extends Served> = T Function(
    InheritedWidget widget);

final class Supplier<T extends Served> extends Widget
    implements InheritedWidget {
  const Supplier({
    super.key,
    required this.init,
    Widget? child,
  }) : _maybeChild = child;

  static Widget multi(
          {required List<Supplier> services, required Widget child}) =>
      MultiSupplier(services: services, child: child);

  static Supplier<ServedStream<T>> stream<T>(Stream<T> stream,
          {T? initialValue}) =>
      Supplier(
          init: (widget) => ServedStream(widget,
              stream: stream, initialValue: initialValue));

  static Supplier<ServedFuture<T>> future<T>(Future<T> future,
          {T? initialValue}) =>
      Supplier(
          init: (widget) => ServedFuture(widget,
              future: future, initialValue: initialValue));

  static Supplier<ServedNotifier<T>> changeNotifier<
          T extends ChangeNotifier>(T changeNotifier) =>
      Supplier(
          init: (widget) =>
              ServedNotifier(widget, notifier: changeNotifier));

  static Supplier<ServedValue<T>> value<T>(T value) =>
      Supplier(init: (widget) => ServedValue(widget, value: value));

  final Widget? _maybeChild;
  final CreateServed<T> init;

  @override
  Widget get child {
    assert(_maybeChild != null,
        '$Supplier must have a child if is not nested inside a ${Supplier.multi} constructor');
    return _maybeChild!;
  }

  @override
  Served createElement() => init(this);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      throw StateError('Handled internally');
}
