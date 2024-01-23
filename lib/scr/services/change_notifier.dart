import 'package:flutter/widgets.dart';
import 'service.dart';
import 'subscription.dart';

class ChangeNotifierService<T extends ChangeNotifier>
    extends SubscriptableService {
  final T changeNotifier;

  ChangeNotifierService(super.widget, {required this.changeNotifier});

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    addChangeNotifier(changeNotifier, onChange: notify);
  }
}

extension ChangeNotifierServiceBuildContextExtensions on BuildContext {
  T readChangeNotifier<T extends ChangeNotifier>() =>
      read<ChangeNotifierService<T>>().changeNotifier;

  void listenChangeNotifier<T extends ChangeNotifier>() =>
      listen<ChangeNotifierService<T>>();
}
