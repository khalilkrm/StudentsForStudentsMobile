import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String key = 'AIzaSyB_s7ekBOaWJjDPJ820C6OFiFDEGgIh53o';
String Function(String) getPlaceIdUrl = (input) =>
    'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
String Function(String) getPlaceUrl = (input) =>
    'https://maps.googleapis.com/maps/api/place/details/json?place_id=$input&key=$key';
String Function(String, String) getDirectionUrl = (origin, destination) =>
    'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';
String Function(double, double) getGeocodeUrl = (lat, lng) =>
    'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$key';

class GoogleMapApi {
  Future<String> fetchPlaceId(String name) async {
    final http.Response response =
        await http.get(Uri.parse(getPlaceIdUrl(name)));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = convert.jsonDecode(response.body);
      final List<dynamic> candidates = data['candidates'];
      if (candidates.isNotEmpty) {
        final String placeId = candidates[0]['place_id'];
        return placeId;
      } else {
        throw Exception("No place found");
      }
    } else {
      throw Exception("Failed to load place");
    }
  }

  Future<Map<String, dynamic>> fetchPlace(String input) async {
    final http.Response response =
        await http.get(Uri.parse(getPlaceIdUrl(input)));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = convert.jsonDecode(response.body);
      final Map<String, dynamic> location =
          data['result'] as Map<String, dynamic>;
      return location;
    } else {
      throw Exception("Failed to load place");
    }
  }

  Future<Map<String, dynamic>> fetchDirection(
      String origin, String destination) async {
    var response =
        await http.get(Uri.parse(getDirectionUrl(origin, destination)));
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      throw Exception("Failed to get direction");
    }
  }

  Future<Map<String, dynamic>> fetchAdressFromLatLng(
      double lat, double lng) async {
    final http.Response response =
        await http.get(Uri.parse(getGeocodeUrl(lat, lng)));
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      throw Exception("Failed to load place");
    }
  }
}
