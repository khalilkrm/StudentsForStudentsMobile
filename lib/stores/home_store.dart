import 'package:flutter/cupertino.dart';

class HomeStore extends ChangeNotifier {
  bool _mode = true;

  bool get mode => _mode;

  void requestsMode() {
    _mode = true;
    notifyListeners();
  }

  void synthesesMode() {
    _mode = false;
    notifyListeners();
  }
}