import 'package:flutter/cupertino.dart';
import 'package:student_for_student_mobile/models/request/RequestModel.dart';
import 'package:student_for_student_mobile/repositories/request_repository.dart';
import 'package:student_for_student_mobile/views/pages/profile_page.dart';

extension _TabBarTopDataModelExtension on TabBarTopDataModel {
  // Private extension to convert RequestModel to TabBarTopDataModel for convenience
  static TabBarTopDataModel from(
      {required RequestModel requestModel, required String currentUsername}) {
    return TabBarTopDataModel(
      requestTitle: requestModel.name,
      requestDescription: requestModel.description,
      courseName: requestModel.course.label,
      requestMeetLocation: requestModel.place.street,
      isAccepted: requestModel.status,
      isMeTheHandler:
          requestModel.status && requestModel.handler == currentUsername,
      handlerUsername: requestModel.status ? requestModel.handler : '',
      onNavigatePressed: () {},
      onCancelPressed: () {},
    );
  }
}

class ProfileStore with ChangeNotifier {
  final RequestRepository _requestRepository;
  List<TabBarTopDataModel> _requests = [];

  ProfileStore({required RequestRepository requestRepository})
      : _requestRepository = requestRepository;

  List<TabBarTopDataModel> get requests => _requests;

  Future<void> getRequests(
      {required String token, required String currentUsername}) async {
    final requests =
        await _requestRepository.getRequests(owned: true, token: token);
    _requests = requests
        .map((request) => _TabBarTopDataModelExtension.from(
            requestModel: request, currentUsername: currentUsername))
        .toList();
    notifyListeners();
  }
}
