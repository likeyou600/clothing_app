import 'dart:convert';

class UserModel {
  String uid;
  String nickname;
  UserModel({
    required this.uid,
    required this.nickname,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      nickname: map['nickname'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
