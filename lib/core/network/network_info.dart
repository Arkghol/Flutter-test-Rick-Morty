import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this.connectivity);
  final Connectivity connectivity;

  StreamController<bool>? _controller;

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    _controller ??= StreamController<bool>.broadcast()
      ..addStream(
        connectivity.onConnectivityChanged.map(
          (result) => !result.contains(ConnectivityResult.none),
        ),
      );
    return _controller!.stream;
  }
}
