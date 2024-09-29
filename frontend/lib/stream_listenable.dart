import 'dart:async';
import 'package:flutter/foundation.dart';

class StreamListenable extends ChangeNotifier {
  final Stream _stream;
  late StreamSubscription _subscription;

  StreamListenable(Stream stream) : _stream = stream {
    _subscription = _stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}