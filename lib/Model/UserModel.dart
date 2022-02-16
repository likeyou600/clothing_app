import 'dart:convert';

class UserModel {
  String uid; //用戶fire_auth id
  String nickname; //暱稱
  String userpic; //頭貼
  bool admin; //true:管理員
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
