import 'package:flutter/widgets.dart';
import 'supplier.dart';

class MultiSupplier extends StatelessWidget {
  final List<Supplier> services;
  final Widget child;

  const MultiSupplier(
      {super.key, required this.services, required this.child});

  @override
  Widget build(BuildContext context) {
    Widget res = child;
    for (var i = services.length; i > 0; --i) {
      res = Supplier(
        init: services[i].init,
        child: res,
      );
    }
    return res;
  }
}
