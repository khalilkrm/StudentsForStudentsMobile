import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:student_for_student_mobile/repositories/home_repository.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';

class HomeStore extends ChangeNotifier {
  final HomeRepository _homeRepository;
  final UserStore _userStore;
  String _errorMessage;
  String _successMessage;
  bool _mode = true;

  HomeStore({required HomeRepository homeRepository, required UserStore userStore})
      : _homeRepository = homeRepository,
        _userStore = userStore,
        _errorMessage = '',
        _successMessage = '';

  load() async {
    bool succeed;

    succeed = await _homeRepository.getRequests();
    if (!succeed) {
      _userStore.signOut();
    }

    notifyListeners();
  }

  get hasRequests => _homeRepository.requests.isNotEmpty;
  get errorMessage => _errorMessage;
  get successMessage => _successMessage;
  get mode => _mode;
  get requests => _homeRepository.requests;


  void requestsMode() {
    _mode = true;
    notifyListeners();
  }

  void synthesesMode() {
    _mode = false;
    notifyListeners();
  }

  acceptRequest(int requestId) async {
    String message = await _homeRepository.acceptRequest(requestId: requestId);

    if(message == 'unauthorized') {
      _userStore.signOut();
    }

    var data = jsonDecode(message);
    if(data['error'] == true) {
      _errorMessage = data['message'];
      _successMessage = '';
    } else {
      _successMessage = data['message'];
      _errorMessage = '';
      await load();
    }

    notifyListeners();
  }
}