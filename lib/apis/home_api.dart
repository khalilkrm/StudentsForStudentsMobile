import 'package:student_for_student_mobile/apis/urls.dart';
import 'package:student_for_student_mobile/repositories/user_repository.dart';
import 'package:http/http.dart' as http;

class HomeApi {
  late final UserRepository? _userRepository;

  void setUserRepository(UserRepository userRepository) {
    _userRepository = userRepository;
  }

  Future<String?> fetchRequests() async {
    Uri requestsUri = Uri.https(base, request);

    http.Response response = await http.get(requestsUri, headers: {
      'Authorization' : 'Bearer ${_userRepository!.userModel!.token}',
    });

    if(response.statusCode == 401) {
      return 'unauthorized';
    }

    if(response.statusCode == 200) {
      return response.body;
    }

    return null;
  }

  Future<String> acceptRequest({required int requestId}) async {
    Uri acceptUri = Uri.https(base, '$request/$requestId');

    http.Response response = await http.put(acceptUri, headers: {
      'Authorization': 'Bearer ${_userRepository!.userModel!.token}',
    });

    if(response.statusCode == 401) {
      return 'unauthorized';
    }

    return response.body;
  }
}