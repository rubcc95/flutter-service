import 'package:flutter/widgets.dart';
import 'served.dart';

typedef ClientBuilder<S extends Served> = Widget Function(S? value);

class Client<S extends Served> extends StatelessWidget {
  const Client(this.builder, {super.key, this.condition});

  final ClientBuilder<S> builder;
  final ClientCondition<S>? condition;

  @override
  Widget build(BuildContext context) =>
      builder((context..listen<S>(condition)).read<S>());
}
