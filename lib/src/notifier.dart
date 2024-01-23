import 'package:flutter/widgets.dart';
import 'served.dart';
import 'subscriptor.dart';

class ServedNotifier<T extends ChangeNotifier>
    extends ServedSubscriptor {
  final T notifier;

  ServedNotifier(super.widget, {required this.notifier});

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    addChangeNotifier(notifier, onChange: notify);
  }
}

extension ServedNotifierContext on BuildContext {
  T readChangeNotifier<T extends ChangeNotifier>() =>
      read<ServedNotifier<T>>().notifier;

  void listenChangeNotifier<T extends ChangeNotifier>() =>
      listen<ServedNotifier<T>>();
}
