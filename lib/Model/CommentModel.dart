import 'dart:convert';

class CommentModel {
  String post_id; //發文ID
  String poster; //發文者
  List postpics; //發文者貼文圖片 以利通知顯示圖片
  String uid; //留言id
  String comment; //留言內容
  DateTime comment_time; //留言時間
  List likes; //留言按讚者
  CommentModel({
    required this.post_id,
    required this.poster,
    required this.postpics,
    required this.uid,
    required this.comment,
    required this.comment_time,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return {
      'post_id': post_id,
      'poster': poster,
      'postpics': postpics,
      'uid': uid,
      'comment': comment,
      'comment_time': comment_time.millisecondsSinceEpoch,
      'likes': likes,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      post_id: map['post_id'] ?? '',
      poster: map['poster'] ?? '',
      postpics: List.from(map['postpics']),
      uid: map['uid'] ?? '',
      comment: map['comment'] ?? '',
      comment_time: DateTime.fromMillisecondsSinceEpoch(map['comment_time']),
      likes: List.from(map['likes']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));
}
