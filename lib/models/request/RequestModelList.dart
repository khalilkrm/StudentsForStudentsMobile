import 'package:student_for_student_mobile/models/request/RequestModel.dart';

class RequestModelList {
  final List<RequestModel> requests;

  RequestModelList({required this.requests});

  factory RequestModelList.fromJson(List<dynamic> json) {
    List<RequestModel> requests = <RequestModel>[];
    requests = json.map((i) => RequestModel.fromJson(i)).toList();

    return RequestModelList(
      requests: requests,
    );
  }
}