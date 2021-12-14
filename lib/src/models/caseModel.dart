
import 'dart:convert';

CaseModel caseModelFromJson(String str) => CaseModel.fromJson(json.decode(str));

String caseModelToJson(CaseModel data) => json.encode(data.toJson());

class CaseModel {
  CaseModel({
    this.id,
    this.name,
    this.description,
    this.date,
    this.latitude,
    this.longitude,
    this.location,
    this.type
  });

  String id;
  String name;
  String description;
  String date;
  String location;
  String latitude;
  String longitude;
  int type;

  factory CaseModel.fromJson(Map<String, dynamic> json) => CaseModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    date: json["date"],
    location: json["location"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    type: json['type']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "date": date,
    "latitude": latitude,
    "longitude": longitude,
    "location" : location,
    'type' : type
  };
}
