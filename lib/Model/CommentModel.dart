import 'dart:convert';

class CommentModel {
  String post_id;
  String poster;
  List postpics;
  String uid;
  String comment;
  DateTime comment_time;
  List likes;
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
