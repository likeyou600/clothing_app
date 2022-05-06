import 'dart:convert';

class LikeModel {
  String post_id; //發文ID
  String poster; //發文者
  List postpics; //發文者貼文圖片 以利通知顯示圖片
  String uid; //按讚id
  DateTime like_time; //時間

  LikeModel({
    required this.post_id,
    required this.poster,
    required this.postpics,
    required this.uid,
    required this.like_time,
  });

  Map<String, dynamic> toMap() {
    return {
      'post_id': post_id,
      'poster': poster,
      'postpics': postpics,
      'uid': uid,
      'like_time': like_time.millisecondsSinceEpoch,
    };
  }

  factory LikeModel.fromMap(Map<String, dynamic> map) {
    return LikeModel(
      post_id: map['post_id'] ?? '',
      poster: map['poster'] ?? '',
      postpics: List.from(map['postpics']),
      uid: map['uid'] ?? '',
      like_time: DateTime.fromMillisecondsSinceEpoch(map['like_time']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LikeModel.fromJson(String source) =>
      LikeModel.fromMap(json.decode(source));
}
