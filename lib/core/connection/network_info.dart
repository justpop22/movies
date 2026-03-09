import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final List<ConnectivityResult> result = await connectivity
        .checkConnectivity();

    print("DEBUG CONNECTION STATUS: $result");

    if (result.contains(ConnectivityResult.none)) {
      return false;
    }

    return true;
  }
}
