import 'package:flutter/widgets.dart';
import 'service.dart';

class ValueService<T> extends Service {
  final T value;

  ValueService(super.widget, {required this.value});
}

extension ValueServiceBuildContextExtension on BuildContext {
  T readValue<T>() => read<ValueService<T>>().value;

  void listenValue<T>() => listen<ValueService<T>>();
}
