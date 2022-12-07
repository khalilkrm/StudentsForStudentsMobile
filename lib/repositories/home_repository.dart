import 'dart:convert';

import 'package:student_for_student_mobile/apis/home_api.dart';
import 'package:student_for_student_mobile/models/request/CourseModel.dart';
import 'package:student_for_student_mobile/models/request/CourseModelList.dart';
import 'package:student_for_student_mobile/models/request/RequestModel.dart';
import 'package:student_for_student_mobile/models/request/RequestModelList.dart';

class HomeRepository {
  final HomeApi _homeApi;
  final List<RequestModel> _requests = [];
  final List<CourseModel> _courses = [];

  HomeRepository({required HomeApi homeApi}) : _homeApi = homeApi;

  Future<bool> getRequests({required String token}) async {
    _requests.clear();
    String? data = await _homeApi.fetchRequests(token: token);

    if (data == 'unauthorized') {
      return false;
    }

    if (data != null) {
      _requests.addAll(RequestModelList.fromJson(jsonDecode(data)).requests);
    }

    return true;
  }

  Future<bool> getCourses({required String token}) async {
    _courses.clear();
    String? data = await _homeApi.fetchCourses(token: token);

    if (data == 'unauthorized') {
      return false;
    }

    if (data != null) {
      _courses.addAll(CourseModelList.fromJson(jsonDecode(data)).courses);
    }
    return true;
  }

  List<RequestModel> get requests => _requests;

  List<CourseModel> get courses => _courses;

  Future<String> acceptRequest({
    required int requestId,
    required String token,
  }) async {
    String data = await _homeApi.acceptRequest(
      requestId: requestId,
      token: token,
    );
    return data;
  }

  filterRequests({required int id, required String token}) async {
    await getRequests(token: token);
    _requests.removeWhere((request) => request.course.id != id);
  }
}
