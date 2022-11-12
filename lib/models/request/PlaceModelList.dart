import 'package:student_for_student_mobile/models/request/PlaceModel.dart';

class PlaceModelList {
  final List<PlaceModel> places;

  PlaceModelList({required this.places});

  factory PlaceModelList.fromJson(List<dynamic> json) {
    List<PlaceModel> places = <PlaceModel>[];
    places = json.map((i) => PlaceModel.fromJson(i)).toList();

    return PlaceModelList(
      places: places,
    );
  }
}