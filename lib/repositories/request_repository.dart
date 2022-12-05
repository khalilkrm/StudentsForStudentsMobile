import 'dart:convert';

import 'package:student_for_student_mobile/apis/request_api.dart';
import 'package:student_for_student_mobile/models/request/CourseModel.dart';
import 'package:student_for_student_mobile/models/request/CourseModelList.dart';
import 'package:student_for_student_mobile/models/request/PlaceModel.dart';
import 'package:student_for_student_mobile/models/request/PlaceModelList.dart';
import 'package:student_for_student_mobile/models/request/RequestModel.dart';

class RequestRepository {
  final RequestApi _requestApi;
  final List<PlaceModel> _places = [];
  final List<CourseModel> _courses = [];

  RequestRepository({required RequestApi requestApi})
      : _requestApi = requestApi;

  Future<bool> getPlaces() async {
    _places.clear();
    String? data = await _requestApi.fetchPlaces();

    if (data == 'unauthorized') {
      return false;
    }

    if (data != null) {
      _places.addAll(PlaceModelList.fromJson(jsonDecode(data)).places);
    }

    return true;
  }

  Future<bool> getCourses() async {
    _courses.clear();
    String? data = await _requestApi.fetchCourses();

    if (data == 'unauthorized') {
      return false;
    }

    if (data != null) {
      _courses.addAll(CourseModelList.fromJson(jsonDecode(data)).courses);
    }
    return true;
  }

  List<PlaceModel> get places => _places;

  List<CourseModel> get courses => _courses;

  Future<String> sendRequest(
      {required String name,
      required String description,
      required int placeId,
      required int courseId}) async {
    String data = await _requestApi.sendRequest(
        name: name,
        description: description,
        placeId: placeId,
        courseId: courseId);
    return data;
  }

  Future<String> sendAddress(
      {required String street,
      required String number,
      required int postalCode,
      required String locality}) async {
    String data = await _requestApi.sendAddress(
        street: street,
        number: number,
        postalCode: postalCode,
        locality: locality);
    return data;
  }

  Future<List<RequestModel>> getRequests({
    required bool owned,
    required String token,
  }) async {
    List<dynamic> data =
        await _requestApi.getRequests(owned: owned, token: token);
    var mapperd =
        data.map((request) => RequestModel.fromJson(request)).toList();
    return mapperd;
  }
}
