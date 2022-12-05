import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:student_for_student_mobile/repositories/home_repository.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';

class HomeStore extends ChangeNotifier {
  final HomeRepository _homeRepository;
  final UserStore _userStore;
  String _errorMessage;
  String _successMessage;
  int _selectedCourseId;

  HomeStore(
      {required HomeRepository homeRepository, required UserStore userStore})
      : _homeRepository = homeRepository,
        _userStore = userStore,
        _errorMessage = '',
        _successMessage = '',
        _selectedCourseId = -1;

  load() async {
    _selectedCourseId = -1;
    bool succeed;

    succeed = await _homeRepository.getRequests();
    if (!succeed) {
      _userStore.signOut();
    }
    succeed = await _homeRepository.getCourses();
    if (!succeed) {
      _userStore.signOut();
    }

    notifyListeners();
  }

  get hasRequests => _homeRepository.requests.isNotEmpty;
  get errorMessage => _errorMessage;
  get successMessage => _successMessage;
  get requests => _homeRepository.requests;
  get courses => _homeRepository.courses;
  get selectedCourseId => _selectedCourseId;

  acceptRequest(int requestId) async {
    String message = await _homeRepository.acceptRequest(requestId: requestId);

    if (message == 'unauthorized') {
      _userStore.signOut();
    }

    
    var data = jsonDecode(message);

    if (data['error'] == true) {
      _errorMessage = data['message'];
      _successMessage = '';
    } else {
      _successMessage = data['message'];
      _errorMessage = '';
      await load();
    }

    notifyListeners();
  }

  filterRequests(int id) async {
    if (_selectedCourseId == id) {
      await load();
      return;
    }

    _selectedCourseId = id;
    await _homeRepository.filterRequests(id);
    notifyListeners();
  }
}
