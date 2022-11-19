import 'dart:convert';

import 'package:student_for_student_mobile/apis/home_api.dart';
import 'package:student_for_student_mobile/models/request/RequestModel.dart';
import 'package:student_for_student_mobile/models/request/RequestModelList.dart';

class HomeRepository {
  final HomeApi _homeApi;
  final List<RequestModel> _requests = [];

  HomeRepository({required HomeApi homeApi})
      : _homeApi = homeApi;

  Future<bool> getRequests() async {
    _requests.clear();
    String? data = await _homeApi.fetchRequests();

    if (data == 'unauthorized') {
      return false;
    }

    if (data != null) {
      _requests.addAll(RequestModelList.fromJson(jsonDecode(data)).requests);
    }

    return true;
  }

  List<RequestModel> get requests => _requests;

  Future<String> acceptRequest({required int requestId}) async {
    String data = await _homeApi.acceptRequest(requestId: requestId);
    return data;
  }
}