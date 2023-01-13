// To parse this JSON data, do
//
//     final memberModel = memberModelFromJson(jsonString);

import 'dart:convert';

List<MemberModel?>? memberModelFromJson(String str) => json.decode(str) == null
    ? []
    : List<MemberModel?>.from(
        json.decode(str)!.map((x) => MemberModel.fromJson(x)));

String memberModelToJson(List<MemberModel?>? data) => json.encode(
    data == null ? [] : List<dynamic>.from(data.map((x) => x!.toJson())));

class MemberModel {
  MemberModel({
    this.id = 0,
    this.name = "",
    this.phone = "",
    this.typeId = 0,
    this.typeName = "",
  });

  int id;
  String name;
  String phone;
  int typeId;
  String typeName;

  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        phone: json["phone"] ?? "",
        typeId: json["typeId"] ?? 0,
        typeName: json["typeName"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "typeId": typeId,
        "typeName": typeName,
      };
}
