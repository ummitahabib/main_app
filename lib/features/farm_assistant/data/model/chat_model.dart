import 'package:intl/intl.dart';
import 'package:smat_crow/utils2/constants.dart';

class ChatModel {
  int? id;
  String? sessionId;
  String? userId;
  String? question;
  String? answer;
  String? textLang;
  bool? isNewChat;
  String? chatTime;
  String? startTime;
  String? audioPath;
  bool? isAudio;
  String? transcribeText;
  String? translateText;

  ChatModel({
    this.answer,
    this.id,
    this.isNewChat = false,
    this.question,
    this.sessionId,
    this.textLang,
    this.userId,
    this.chatTime,
    this.startTime,
    this.audioPath,
    this.transcribeText = "",
    this.translateText = "",
    this.isAudio = false,
  });

  ChatModel.fromJson({required Map<String, dynamic> chatData}) {
    id = chatData["id"];
    sessionId = chatData["session_id"];
    userId = chatData["user_id"];
    question = chatData["question"];
    answer = chatData["answer"];
    textLang = chatData["ext_lang"] ?? "";
    isNewChat = false;
    transcribeText = "";
    translateText = "";
    chatTime = getTimeFromChatTime(dateTime: chatData["updated_at"]);
    startTime = getTimeFromChatTime(dateTime: chatData["created_at"]);
    isAudio = false;
  }

  @override
  String toString() {
    final Map<String, dynamic> data = {
      "id": id,
      "sessionId": sessionId,
      "userId": userId,
      "question": question,
      "answer": answer,
      "textlang": textLang,
      "chatTIme": chatTime,
      "isAudio": isAudio,
      "transcribeText": transcribeText,
      "translateText": translateText,
      "startTime": startTime,
    };
    return data.toString();
  }
}

String getTimeFromChatTime({required String? dateTime}) {
  if (dateTime != null) {
    final DateTime date = DateTime.parse(dateTime);
    final String returnedString = DateFormat('HH:MM').format(date);
    return returnedString;
  }
  return emptyString;
}
