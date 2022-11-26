import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String key = 'AIzaSyB_s7ekBOaWJjDPJ820C6OFiFDEGgIh53o';
String Function(String) getPlaceIdUrl = (input) =>
    'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
String Function(String) getPlaceUrl = (input) =>
    'https://maps.googleapis.com/maps/api/place/details/json?place_id=$input&key=$key';
String Function(String, String) getDirectionUrl = (origin, destination) =>
    'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';

class GoogleMapApi {
  Future<String> getPlaceId(String name) async {
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

  Future<Map<String, dynamic>> getPlace(String input) async {
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

  Future<Map<String, dynamic>> getDirection(
      String origin, String destination) async {
    var response =
        await http.get(Uri.parse(getDirectionUrl(origin, destination)));
    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      var results = {
        'bounds_ne': json['routes'][0]['bounds']['northeast'],
        'bounds_sw': json['routes'][0]['bounds']['southwest'],
        'start_location': json['routes'][0]['legs'][0]['start_location'],
        'end_location': json['routes'][0]['legs'][0]['end_location'],
        'polyline': json['routes'][0]['overview_polyline']['points'],
        'polyline_decoded': PolylinePoints()
            .decodePolyline(json['routes'][0]['overview_polyline']['points']),
      };
      return results;
    } else {
      throw Exception("Failed to get direction");
    }
  }

  Future<String> getAdressFromLatLng(double lat, double lng) async {
    final http.Response response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$key'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = convert.jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      if (results.isNotEmpty) {
        final String address = results[0]['formatted_address'];
        return address;
      } else {
        throw Exception("No place found");
      }
    } else {
      throw Exception("Failed to load place");
    }
  }
}
