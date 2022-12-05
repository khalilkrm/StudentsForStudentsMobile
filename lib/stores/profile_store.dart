import 'package:flutter/cupertino.dart';
import 'package:student_for_student_mobile/models/request/RequestModel.dart';
import 'package:student_for_student_mobile/repositories/request_repository.dart';

class ProfileStore with ChangeNotifier {
  final RequestRepository _requestRepository;
  List<ProfileDataModel> _requests = [];

  ProfileStore({required RequestRepository requestRepository})
      : _requestRepository = requestRepository;

  bool get isHandledRequestsEmpty => getHandledRequest().isEmpty;
  bool get isCreatedRequestsEmpty => getCreatedRequest().isEmpty;

  /// Owned requests means requests that I created or accepted
  Future<void> loadOwnedRequests({required String token}) async {
    final requests =
        await _requestRepository.getRequests(owned: true, token: token);
    _requests = requests
        .map((request) => _TabBarTopDataModelExtension.from(
            requestModel: request, currentUsername: request.sender))
        .toList();
    notifyListeners();
  }

  /// Handled requests means requests that I accepted
  List<ProfileDataModel> getHandledRequest() {
    return _requests.where((request) => request.isMeTheHandler).toList();
  }

  /// Created requests means requests that I created
  List<ProfileDataModel> getCreatedRequest() {
    return _requests.where((request) => !request.isMeTheHandler).toList();
  }
}

/// ata model specific to the profile page
class ProfileDataModel {
  final bool isAccepted;
  final bool isMeTheHandler;
  final String handlerUsername;
  final String requestTitle;
  final String requestDescription;
  final String courseName;
  final String requestMeetLocation;
  final void Function() onNavigatePressed;
  final void Function() onCancelPressed;

  ProfileDataModel({
    required this.requestTitle,
    required this.requestDescription,
    required this.courseName,
    required this.requestMeetLocation,
    required this.isAccepted,
    required this.isMeTheHandler,
    required this.handlerUsername,
    required this.onNavigatePressed,
    required this.onCancelPressed,
  });
}

//--------------------------
// Extension
//--------------------------

extension _TabBarTopDataModelExtension on ProfileDataModel {
  /// Private extension to convert RequestModel to TabBarTopDataModel for convenience
  static ProfileDataModel from(
      {required RequestModel requestModel, required String currentUsername}) {
    return ProfileDataModel(
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
