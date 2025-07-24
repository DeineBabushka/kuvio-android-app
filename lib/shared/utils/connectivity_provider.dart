import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:kuvio/shared/services/offline_cache_service.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    _checkConnection();
    Timer.periodic(const Duration(seconds: 2), (_) => _checkConnection());
  }

  Future<void> _checkConnection() async {
    final previousStatus = _isOnline;

    try {
      final result = await InternetAddress.lookup('google.com');
      _isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      _isOnline = false;
    }

    if (!_wasPreviouslyOnline(previousStatus) && _isOnline) {
      await OfflineCacheService.preloadAll();
      if (_isOnline != previousStatus) {
        notifyListeners();
      }
    }
  }

  bool _wasPreviouslyOnline(bool previous) => previous == true;
}
