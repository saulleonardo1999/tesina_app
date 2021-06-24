
import 'dart:convert';

CaseModel caseModelFromJson(String str) => CaseModel.fromJson(json.decode(str));

String caseModelToJson(CaseModel data) => json.encode(data.toJson());

class CaseModel {
  CaseModel({
    this.id,
    this.name,
    this.description,
    this.date,
    this.photo,
    this.latitude,
    this.longitude,
    this.location
  });

  String id;
  String name;
  String description;
  String date;
  String location;
  String photo;
  String latitude;
  String longitude;

  factory CaseModel.fromJson(Map<String, dynamic> json) => CaseModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    date: json["date"],
    location: json["location"],
    photo: json["photo"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "date": date,
    "photo": photo,
    "latitude": latitude,
    "longitude": longitude,
    "location" : location
  };
}
