import 'package:flutter/widgets.dart';
import 'service.dart';
import 'subscriptions.dart';

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
  ChangeNotifierService<T> readChangeNotifier<T extends ChangeNotifier>() => read();
  void listenChangeNotifier<T extends ChangeNotifier>() => listen<ChangeNotifierService<T>>();  
}