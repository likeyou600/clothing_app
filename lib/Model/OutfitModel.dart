import 'dart:convert';

class OutfitModel {
  String poster;
  String date;
  String clothes;
  String pants;
  OutfitModel({
    required this.poster,
    required this.date,
    required this.clothes,
    required this.pants,
  });

  Map<String, dynamic> toMap() {
    return {
      'poster': poster,
      'date': date,
      'clothes': clothes,
      'pants': pants,
    };
  }

  factory OutfitModel.fromMap(Map<String, dynamic> map) {
    return OutfitModel(
      poster: map['poster'] ?? '',
      date: map['date'] ?? '',
      clothes: map['clothes'] ?? '',
      pants: map['pants'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OutfitModel.fromJson(String source) =>
      OutfitModel.fromMap(json.decode(source));

  set(Map<String, dynamic> json) {}
}
