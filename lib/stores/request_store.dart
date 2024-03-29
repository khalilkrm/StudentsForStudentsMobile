import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:student_for_student_mobile/repositories/request_repository.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';

class RequestStore extends ChangeNotifier {
  final RequestRepository _requestRepository;
  final UserStore _userStore;
  String _errorMessage;
  String _successMessage;
  bool _mode;

  RequestStore(
      {required RequestRepository requestRepository,
      required UserStore userStore})
      : _requestRepository = requestRepository,
        _userStore = userStore,
        _errorMessage = '',
        _successMessage = '',
        _mode = false;

  load({required String token}) async {
    bool succeed;

    succeed = await _requestRepository.getPlaces(token: token);
    if (!succeed) {
      await _userStore.signOut();
    }
    succeed = await _requestRepository.getCourses(token: token);
    if (!succeed) {
      await _userStore.signOut();
    }

    notifyListeners();
  }

  get errorMessage => _errorMessage;

  get successMessage => _successMessage;

  get mode => _mode;

  get places => _requestRepository.places;

  get courses => _requestRepository.courses;

  changeMode() {
    _mode = !_mode;
    notifyListeners();
  }

  sendRequest(
    String token, {
    required String name,
    required String description,
    required int placeId,
    required int courseId,
  }) async {
    String message = await _requestRepository.sendRequest(token,
        name: name,
        description: description,
        placeId: placeId,
        courseId: courseId);

    if (message == 'unauthorized') {
      await _userStore.signOut();
    }

    var data = jsonDecode(message);
    if (data['error'] == true) {
      _errorMessage = data['message'];
      _successMessage = '';
    } else {
      _successMessage = data['message'];
      _errorMessage = '';
    }
    notifyListeners();
  }

  sendAddress(String token,
      {required String street,
      required String number,
      required int postalCode,
      required String locality}) async {
    String message = await _requestRepository.sendAddress(token,
        street: street,
        number: number,
        postalCode: postalCode,
        locality: locality);

    if (message == 'unauthorized') {
      await _userStore.signOut();
    }

    var data = jsonDecode(message);
    if (data['error'] == true) {
      _errorMessage = data['message'];
      _successMessage = '';
    } else {
      _successMessage = data['message'];
      _errorMessage = '';
      await load(token: token);
      changeMode();
    }
    notifyListeners();
  }
}
