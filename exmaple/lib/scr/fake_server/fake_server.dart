import 'dart:math';
import 'package:flutter/material.dart';
part 'constants.dart';

class _FakeDelayer {
  _FakeDelayer([int? seed]) : random = Random(seed);

  final Random random;

  Future<void> _fakeWait() => _fakeFuture(() {});

  Future<T> _fakeFuture<T>(T Function() builder) =>
      Future.delayed(Duration(seconds: 500 + random.nextInt(2500)), builder);

  Stream<T> fakeStream<T>(T Function() builder) async* {
    while (true) {
      yield await _fakeFuture(builder);
    }
  }
}

class FakeServer extends _FakeDelayer {
  static _entry(String name) => MapEntry(name, FakeUser(name));

  FakeUser? _currentUser;

  final Map<String, FakeUser> _users = Map.fromEntries({
    _entry('Carol'),
    _entry('Sam'),
    _entry('Dylan'),
    _entry('Alice'),
  });

  Future<FakeUser> logIn(String name) => _fakeFuture(
      () => _currentUser = _users.putIfAbsent(name, () => FakeUser(name)));

  Future<void> logOut() => _fakeFuture(() => _currentUser = null);

  Future<List<FakeUser>> getUsers() =>
      _fakeFuture(() => _users.values.toList());

  FakeUser? get currentUser => _currentUser;
}

extension _RandomListExtension<T> on List<T> {
  T random([Random? random]) => this[(random ?? Random()).nextInt(length)];

  void setRandom(T value, [Random? random]) =>
      this[(random ?? Random()).nextInt(length)] = value;
}

class FakeUser extends _FakeDelayer {
  final String name;
  List<String>? _description;
  final List<IconData> _icons = [];
  FakeUser(
    this.name,
  ) : super(name.hashCode);

  Future<void> addIcon() =>
      _fakeFuture(() => _icons.add(_kAllIcons.random(random)));

  Stream<String> getDescription() => fakeStream(() {
        if (_description == null) {
          _description = List.generate(
              10 + random.nextInt(40), (_) => _kLoremIpsum.random(random));
        } else {
          _description!.setRandom(_kLoremIpsum.random(random), random);
        }
        return _description!.join(' ');
      });
}
