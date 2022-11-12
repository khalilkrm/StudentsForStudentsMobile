import 'package:json_annotation/json_annotation.dart';

part 'PlaceModel.g.dart';

@JsonSerializable()
class PlaceModel {
  final int id;
  final String street;
  final int postalCode;
  final String number;
  final String locality;

  PlaceModel({
    required this.id,
    required this.street,
    required this.postalCode,
    required this.number,
    required this.locality,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceModelFromJson(json);

  get content {
    String address = "$street $number, $postalCode $locality";
    return "${address.substring(0, address.length < 45 ? address.length : 45)}${address.length > 45 ? "..." : ""}";
  }
}