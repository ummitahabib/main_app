import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  List<String>? url;
  String? userName;
  String? userUrl;

  Story(this.url, this.userName, this.userUrl);

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      json['url']?.cast<String>(),
      json['userName'],
      json['userUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'userName': userName,
      'userUrl': userUrl,
    };
  }

  static List<Story> fromJsonList(String json) {
    final List<dynamic> parsedJson = jsonDecode(json);
    return parsedJson.map((json) => Story.fromJson(json)).toList();
  }

  static String toJsonList(List<Story> stories) {
    final List<Map<String, dynamic>> storyList =
        stories.map((story) => story.toJson()).toList();
    return jsonEncode(storyList);
  }

  static Story fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return Story(
      data['storyUrl']?.cast<String>(),
      data['userName'],
      data['userUrl'],
    );
  }
}
