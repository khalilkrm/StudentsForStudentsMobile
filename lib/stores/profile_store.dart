import 'package:flutter/cupertino.dart';
import 'package:student_for_student_mobile/models/request/RequestModel.dart';
import 'package:student_for_student_mobile/repositories/request_repository.dart';

class ProfileStore with ChangeNotifier {
  final RequestRepository _requestRepository;
  List<ProfileDataModel> _requests = [];
  List<ProfileDataModel> handledRequests = [];
  List<ProfileDataModel> createdRequests = [];
  String? error;

  ProfileStore({required RequestRepository requestRepository})
      : _requestRepository = requestRepository;

  bool get isHandledRequestsEmpty => handledRequests.isEmpty;
  bool get isCreatedRequestsEmpty => createdRequests.isEmpty;

  /// Owned requests means requests that I created or accepted
  Future<void> loadOwnedRequests({
    required String token,
    required String currentUsername,
  }) async {
    final requests =
        await _requestRepository.getRequests(owned: true, token: token);
    _requests = requests
        .map((request) => request.toProfileDataModel(
              currentUsername: currentUsername,
              removeRequest: (id, token) =>
                  cancelRequest(requestId: id, token: token),
            ))
        .toList();
    handledRequests = List.unmodifiable(getHandledRequest());
    createdRequests = List.unmodifiable(getCreatedRequest());
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

  Future<void> cancelRequest({
    required int requestId,
    required String token,
  }) async {
    try {
      await _requestRepository.deleteRequest(
        id: requestId,
        token: token,
      );
      _requests.removeWhere((request) => request.id == requestId);
      handledRequests = List.unmodifiable(getHandledRequest());
      createdRequests = List.unmodifiable(getCreatedRequest());
    } on Exception catch (e) {
      error = e.toString();
    } finally {
      notifyListeners();
    }
  }
}

/// Data model specific to the profile page
class ProfileDataModel {
  final int id;
  final bool isAccepted;
  final bool isMeTheHandler;
  final String handlerUsername;
  final String requestTitle;
  final String requestDescription;
  final String courseName;
  final String requestMeetLocation;
  final String meetingDate;
  final Future<void> Function(int, String) onCancelPressed;

  ProfileDataModel({
    required this.id,
    required this.requestTitle,
    required this.requestDescription,
    required this.courseName,
    required this.requestMeetLocation,
    required this.isAccepted,
    required this.isMeTheHandler,
    required this.handlerUsername,
    required this.onCancelPressed,
    required this.meetingDate,
  });
}

//--------------------------
// Extension
//--------------------------

extension _TabBarTopDataModelExtension on RequestModel {
  /// Private extension to convert RequestModel to TabBarTopDataModel for convenience
  ProfileDataModel toProfileDataModel({
    required Future<void> Function(int, String) removeRequest,
    required String currentUsername,
  }) {
    return ProfileDataModel(
      id: id,
      requestTitle: name,
      requestDescription: description,
      courseName: course.label,
      requestMeetLocation: place.address,
      isAccepted: status,
      isMeTheHandler: status && handler == currentUsername,
      handlerUsername: status ? handler : '',
      onCancelPressed: (id, token) => removeRequest(id, token),
      meetingDate: getFormatedDate(),
    );
  }
}
