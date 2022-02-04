import 'dart:convert';

class UserModel {
  String uid;
  String nickname;
  String userpic;
  UserModel({
    required this.uid,
    required this.nickname,
    required this.userpic,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
      'userpic': userpic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      nickname: map['nickname'] ?? '',
      userpic: map['userpic'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
