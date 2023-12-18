class USerSessionModel {
  String? id;
  String? sessionId;
  String? userId;
  String? name;
  bool? isNewChat;
  USerSessionModel({this.id, this.name, this.sessionId, this.userId, this.isNewChat});
  USerSessionModel.fromjson({required Map<String, dynamic> userData}) {
    id = userData["id"].toString();
    sessionId = userData["session_id"];
    userId = userData["user_id"];
    name = userData["name"];
    isNewChat = false;
  }

  @override
  String toString() {
    final Map<String, dynamic> data = {
      "id": id,
      "sessionId": sessionId,
      "userId": userId,
      "name": name,
      "isNewChat": isNewChat,
    };
    return data.toString();
  }
}
