import 'dart:convert';

List<CharacterModel> characterFromJson(String str) => List<CharacterModel>.from(
    json.decode(str).map((x) => CharacterModel.fromJson(x)));

String characterToJson(List<CharacterModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CharacterModel {
  CharacterModel({
    required this.name,
    required this.birthday,
    required this.img,
  });

  String name;
  String birthday;
  String img;

  factory CharacterModel.fromJson(Map<String, dynamic> json) => CharacterModel(
        name: json["name"],
        birthday: json["birthday"],
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "birthday": birthday,
        "img": img,
      };
}
