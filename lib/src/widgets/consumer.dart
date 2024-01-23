import 'package:flutter/widgets.dart';
import '../services/service.dart';

typedef ConsumeServiceCallback<T extends Service> = Widget Function(T? value);

class ServiceConsumer<T extends Service> extends StatelessWidget {
  const ServiceConsumer(this.builder, {super.key, this.condition});

  final ConsumeServiceCallback<T> builder;
  final ServiceListenCondition<T>? condition;

  @override
  Widget build(BuildContext context) =>
      builder((context..listen<T>(condition)).read<T>());
}
