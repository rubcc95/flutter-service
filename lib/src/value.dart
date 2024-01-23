import 'package:flutter/widgets.dart';
import 'served.dart';

class ServedValue<T> extends Served {
  final T value;

  ServedValue(super.widget, {required this.value});
}

extension ServedValueContext on BuildContext {
  T readValue<T>() => read<ServedValue<T>>().value;

  void listenValue<T>() => listen<ServedValue<T>>();
}
