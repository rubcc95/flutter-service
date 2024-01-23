import 'package:flutter/widgets.dart';
import 'package:service_framework/scr/widgets/widget.dart';

class MultiServiceWidget extends StatelessWidget {
  final List<ServiceWidget> services;
  final Widget child;

  const MultiServiceWidget(
      {super.key, required this.services, required this.child});

  @override
  Widget build(BuildContext context) {
    Widget res = child;
    for (var i = services.length; i > 0; --i) {
      res = ServiceWidget(
        init: services[i].init,
        child: res,
      );
    }
    return res;
  }
}
