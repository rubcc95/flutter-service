import 'package:flutter/foundation.dart';
import 'package:service_framework/service_framework.dart';

import '../fake_server/fake_server.dart';

final server = FakeServer();

class AuthService extends SubscriptableService {
  AuthService(super.widget);

  FakeUser? _user;
  // a callback to cancel to logIn / logOut operation, if exists.
  VoidCallback? _cancelProcess;

  void logIn(String name) {
    //if some operation is being performed or service has already a user, do nothing.
    if (inProcess || hasUser) return;

    _cancelProcess = addFuture<FakeUser>(server.logIn(name), onData: (data) {
      _cancelProcess = null;
      _user = data;
      notify();
    });

    notify();
  }

  //really similar to logIn
  void logOut(String name) {
    if (inProcess || !hasUser) return;

    _cancelProcess = addFuture(server.logOut(), onData: (_) {
      _cancelProcess = null;
      _user = null;
      notify();
    });

    notify();
  }

  bool get inProcess => _cancelProcess != null;
  bool get hasUser => _user != null;
  FakeUser get user => _user!;
}
