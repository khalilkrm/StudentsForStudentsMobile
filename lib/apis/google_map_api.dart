import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String key = 'AIzaSyB_s7ekBOaWJjDPJ820C6OFiFDEGgIh53o';
String Function(String, String) getDirectionUrl = (origin, destination) =>
    'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';
String Function(double, double) getGeocodeUrl = (lat, lng) =>
    'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$key';

class GoogleMapApi {
  Future<Map<String, dynamic>> fetchDirection(
      String origin, String destination) async {
    var directions = getDirectionUrl(origin, destination);
    var response = await http.get(Uri.parse(directions));
    if (response.statusCode == 200) {
      var body = response.body;
      return convert.jsonDecode(body);
    } else {
      throw Exception("Failed to get direction");
    }
  }

  Future<Map<String, dynamic>> fetchAdressFromLatLng(
      double lat, double lng) async {
    var code = getGeocodeUrl(lat, lng);
    final http.Response response = await http.get(Uri.parse(code));
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      throw Exception("Failed to load place");
    }
  }
}
