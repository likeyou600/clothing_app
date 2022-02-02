import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String poster;
  String content;
  DateTime publish_time;
  bool reported;
  List postpics;
  List likes;
  List collections;
  PostModel({
    required this.poster,
    required this.content,
    required this.publish_time,
    required this.reported,
    required this.postpics,
    required this.likes,
    required this.collections,
    poster_nickname,
  });

  Map<String, dynamic> toMap() {
    return {
      'poster': poster,
      'content': content,
      'publish_time': publish_time.millisecondsSinceEpoch,
      'reported': reported,
      'postpics': postpics,
      'likes': likes,
      'collections': collections,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      poster: map['poster'] ?? '',
      content: map['content'] ?? '',
      publish_time: DateTime.fromMillisecondsSinceEpoch(map['publish_time']),
      reported: map['reported'] ?? false,
      postpics: List.from(map['postpics']),
      likes: List.from(map['likes']),
      collections: List.from(map['collections']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));
}
