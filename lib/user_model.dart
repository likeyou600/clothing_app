import 'dart:convert';

class UserModel {
  String nickname;
  String uid;
  UserModel({
    required this.nickname,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      nickname: map['nickname'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}

// your document id should be same as uid. 