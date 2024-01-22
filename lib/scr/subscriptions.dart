import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:service/scr/services.dart';

typedef SubscriptionCallback = VoidCallback Function(
    VoidCallback removeSubscription);
typedef DataCallback<T> = void Function(T data);
typedef DoneCallback = void Function();
typedef ErrorCallback = void Function(Object error, StackTrace stackTrace);

mixin SubscriptableServiceMixin on Service {
  final List<VoidCallback> _cancelCallbacks = [];

  VoidCallback addSubscription(SubscriptionCallback builder) {
    late VoidCallback cancel;
    _cancelCallbacks
        .add(cancel = builder(() => _cancelCallbacks.remove(cancel)));
    return cancel;
  }

  VoidCallback addStream<T>(Stream<T> stream, DataCallback<T>? onData,
          {DoneCallback? onDone,
          ErrorCallback? onError,
          bool cancelOnError = false}) =>
      addSubscription((removeSubscription) => stream
          .listen(
            onData,
            onDone: onDone == null
                ? removeSubscription
                : () {
                    removeSubscription();
                    onDone();
                  },
            onError: cancelOnError
                ? onError == null
                    ? (Object error, StackTrace stackTrace) {
                      removeSubscription();
                      Error.throwWithStackTrace(error, stackTrace);
                    }
                    : (Object error, StackTrace stackTrace) {
                        removeSubscription();
                        onError(error, stackTrace);
                      }
                : onError,
          )
          .cancel);

  VoidCallback addFuture<T>(Future<T> future, DataCallback<T>? onData,
          {ErrorCallback? onError}) =>
      addSubscription((removeSubscription) {
        bool canceled = false;
        future.then(
            onData == null
                ? (value) {
                    if (canceled) return;
                    removeSubscription();
                  }
                : (value) {
                    if (canceled) return;
                    removeSubscription();
                    onData(value);
                  },
            onError: onError == null
                ? (error, stackTrace) {
                    if (canceled) return;
                    removeSubscription();
                    Error.throwWithStackTrace(error, stackTrace);                    
                  }
                : (error, stackTrace) {
                    removeSubscription();
                    return onError(error, stackTrace);
                  });
        return () => canceled = true;
      });

  VoidCallback addChangeNotifier(
          ChangeNotifier changeNotifier, VoidCallback onChange) =>
      addSubscription((removeSubscription) {
        changeNotifier.addListener(onChange);
        return () => changeNotifier.removeListener(onChange);
      });

  @override
  void unmount() {
    for (final callback in _cancelCallbacks) {
      callback();
    }
    _cancelCallbacks.clear();
    super.unmount();
  }
}

class SubscriptableService = Service with SubscriptableServiceMixin;