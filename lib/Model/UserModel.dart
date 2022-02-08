import 'dart:convert';

class UserModel {
  String uid;
  String nickname;
  String userpic;
  bool admin;
  UserModel({
    required this.uid,
    required this.nickname,
    required this.userpic,
    required this.admin,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
      'userpic': userpic,
      'admin': admin,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      nickname: map['nickname'] ?? '',
      userpic: map['userpic'] ?? '',
      admin: map['admin'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
