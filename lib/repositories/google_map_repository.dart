import 'package:student_for_student_mobile/apis/google_map_api.dart';
import 'package:student_for_student_mobile/models/map/route.dart';

class GoogleMapRepository {
  final GoogleMapApi _api;

  GoogleMapRepository({required GoogleMapApi api}) : _api = api;

  Future<Route> getRoute(
    String origin,
    String destination,
  ) async {
    var json = await _api.fetchDirection(origin, destination);
    return Route.fromJson(json);
  }

  Future<String> fetchAdressFromLatLng(
      double latitude, double longitude) async {
    final Map<String, dynamic> data =
        await _api.fetchAdressFromLatLng(latitude, longitude);
    final List<dynamic> results = data['results'];
    if (results.isNotEmpty) {
      final String address = results[0]['formatted_address'];
      return address;
    } else {
      throw Exception("No place found");
    }
  }
}
