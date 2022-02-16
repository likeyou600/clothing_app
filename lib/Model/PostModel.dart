import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String poster; //發文者
  String content; //發文內容
  DateTime publish_time; //發文時間
  bool reported; //true:被檢舉
  List postpics; // 發文照片
  List likes; //按讚者
  List collections; //收藏者
  int collections_number; //收藏人數
  PostModel({
    required this.poster,
    required this.content,
    required this.publish_time,
    required this.reported,
    required this.postpics,
    required this.likes,
    required this.collections,
    required this.collections_number,
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
      'collections_number': collections_number,
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
      collections_number: map['collections_number']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));
}
