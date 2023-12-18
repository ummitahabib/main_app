import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/farm_assistant/data/model/chat_model.dart';
import 'package:smat_crow/features/farm_assistant/data/model/language_model.dart';
import 'package:smat_crow/features/farm_assistant/data/model/user_session_model.dart';
import 'package:smat_crow/features/farm_assistant/data/repository/farm_assistant_repository.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/dialog.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/constants.dart';

final farmAssistanceProvider =
    ChangeNotifierProvider<FarmAssistantNotifier>((ref) {
  return FarmAssistantNotifier(ref);
});
Pandora _pandora = Pandora();

class FarmAssistantNotifier extends ChangeNotifier {
// // chat Controller

  TextEditingController chatController = TextEditingController();
  void clearController() {
    chatController.clear();
    notifyListeners();
  }

  final Ref ref;
  FarmAssistantNotifier(this.ref);
  FarmAssistanceRepository farmAssistanceRepository =
      FarmAssistanceRepository();

  String playingAudio = "-1";
  void setPlayingAudio(String newplayingAudio) {
    playingAudio = newplayingAudio;
    notifyListeners();
  }

  void resetPlayingAudio() {
    playingAudio = "-1";
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  LanguageModel? _selectedLanguage;
  LanguageModel? get selectedLanguage => _selectedLanguage;
  set selectedLanguage(LanguageModel? newLanguage) {
    _selectedLanguage = newLanguage;
    notifyListeners();
  }

  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;

  set languages(List<LanguageModel> languageModel) {
    _languages = languageModel;
    notifyListeners();
  }

  USerSessionModel? _selectedSession;
  USerSessionModel? get selectedSession => _selectedSession;
  set selectedSession(USerSessionModel? newSession) {
    _selectedSession = newSession;
    if (!_chats.containsKey(newSession!.sessionId)) {
      getChatHistory(sessionId: newSession.sessionId!);
    }
    notifyListeners();
  }

  List<USerSessionModel> _userSessionDatas = [];
  List<USerSessionModel> get userSessionDatas => _userSessionDatas;

  final Map<String, List<ChatModel>> _chats = {};

  List<ChatModel> getChats({required String? selectedSession}) {
    final bool containKey = _chats.containsKey(selectedSession);
    if (containKey) {
      return _chats[selectedSession] ?? [];
    } else {
      return [];
    }
  }

  set userSessionDatas(List<USerSessionModel> newSserSessionDatas) {
    _userSessionDatas = newSserSessionDatas;
    notifyListeners();
  }

  Future<void> getSupportedLanguages() async {
    if (languages.isEmpty) {
      try {
        final resp = await farmAssistanceRepository.getSupportedLanguages();
        if (resp.hasError()) {
        } else {
          final List<LanguageModel> apiReturnedlanguages =
              resp.response as List<LanguageModel>;
          languages = resp.response;
          selectedLanguage = apiReturnedlanguages[2];
        }
      } catch (e) {
        _pandora.logAPIEvent(
          'supported-languages',
          '$baseUrl/farmprobe/supported-languages',
          'FAILED',
          e.toString(),
        );
        //
      }
    }
  }

  Future<void> getUserSessions() async {
    if (userSessionDatas.isEmpty) {
      try {
        final resp = await farmAssistanceRepository.getUserSession();
        if (resp.hasError()) {
        } else {
          userSessionDatas = resp.response;
        }
      } catch (e) {
        _pandora.logAPIEvent(
          'user-sessions',
          '$baseUrl/farmprobe/user-sessions',
          'FAILED',
          e.toString(),
        );
      }
    }
    await createSessions();
  }

  Future<void> deleteSessions({required USerSessionModel userSession}) async {
    loading = true;
    try {
      final resp = await farmAssistanceRepository.deleteSession(
        sessionId: userSession.sessionId!,
      );
      if (resp.hasError()) {
        snackBarMsg(
          resp.error?.message ?? unableToDeleteSession,
        );
      } else {
        userSessionDatas.removeWhere(
          (element) => element.sessionId == userSession.sessionId,
        );
        if (selectedSession == userSession) {
          if (userSessionDatas.isNotEmpty) {
            selectedSession = userSessionDatas[0];
          } else {
            await createSessions();
          }
        }
        final String message = resp.response as String;
        snackBarMsg(message);
      }
    } catch (e) {
      _pandora.logAPIEvent(
        'session-history${userSession.sessionId!}',
        '$baseUrl/farmprobe/delete-session/${userSession.sessionId!}',
        'FAILED',
        e.toString(),
      );
      //
    }
    loading = false;
  }

  Future<void> createSessions() async {
    loading = true;
    try {
      final resp = await farmAssistanceRepository.createSession();
      if (resp.hasError()) {
        snackBarMsg(
          resp.error?.message ?? unableTOCreateSession,
        );
      } else {
        final String newSessionId = resp.response;
        final USerSessionModel newUserSession = USerSessionModel(
          sessionId: newSessionId,
          name: newSessionId,
          isNewChat: true,
        );
        userSessionDatas.insert(0, newUserSession);
        selectedSession = newUserSession;
        final String newKey = newUserSession.sessionId!;
        final ChatModel newChat = ChatModel(
          answer: helloIAmFarmAssistant,
          sessionId: newKey,
          chatTime: parseDateTimeToTime(),
        );
        _chats[newKey] = [newChat];
      }
    } catch (e) {
      _pandora.logAPIEvent(
        'create-session',
        '$baseUrl/farmprobe//create-session',
        'FAILED',
        e.toString(),
      );
      //
    }
    loading = false;
  }

  Future<void> getChatHistory({required String sessionId}) async {
    loading = true;
    try {
      final resp =
          await farmAssistanceRepository.getChatHistory(sessionId: sessionId);
      if (resp.hasError()) {
        snackBarMsg(
          resp.error?.message ?? unableToGetChatHistory,
        );
      } else {
        final List<ChatModel> newChats = resp.response;
        if (newChats.isEmpty) {
          final String newKey = sessionId;
          userSessionDatas
              .firstWhere((element) => element.sessionId == sessionId)
              .isNewChat = true;
          final ChatModel newCreatedChat = ChatModel(
            answer: helloIAmFarmAssistant,
            sessionId: newKey,
            chatTime: parseDateTimeToTime(),
          );
          _chats[newKey] = [newCreatedChat];
        } else {
          _chats[sessionId] = newChats;
        }
      }
    } catch (e) {
      _pandora.logAPIEvent(
        'session-history$sessionId!',
        '$baseUrl/farmprobe/session-history/$sessionId!',
        'FAILED',
        e.toString(),
      );
      //
    }
    loading = false;
  }

  Future<void> chatWithBot() async {
    if (chatController.text.isNotEmpty) {
      final String startTime = parseDateTimeToTime();
      _chats[selectedSession!.sessionId!]!.insert(
        0,
        ChatModel(
          chatTime: parseDateTimeToTime(),
          isNewChat: true,
          startTime: startTime,
          question: chatController.text,
          sessionId: selectedSession!.sessionId,
        ),
      );
      notifyListeners();
      try {
        final resp = await farmAssistanceRepository.chatWithBot(
          sessionId: selectedSession!.sessionId!,
          input: chatController.text,
        );
        if (resp.hasError()) {
          snackBarMsg(
            resp.error?.message ?? unableToContinue,
          );
          _chats[selectedSession!.sessionId]!.removeAt(0);
        } else {
          _chats[selectedSession!.sessionId]![0] = ChatModel(
            chatTime: parseDateTimeToTime(),
            question: chatController.text,
            startTime: startTime,
            sessionId: selectedSession!.sessionId,
            answer: resp.response["message"],
          );
          final bool isNewChat = userSessionDatas
              .firstWhere(
                (element) => element.sessionId == selectedSession!.sessionId,
              )
              .isNewChat!;

          if (isNewChat) {
            userSessionDatas
                .firstWhere(
                  (element) => element.sessionId == selectedSession!.sessionId,
                )
                .name = resp.response["sessionName"];
          }
        }
      } catch (e) {
        _chats[selectedSession!.sessionId]!.removeAt(0);
        _pandora.logAPIEvent(
          'chat',
          '$baseUrl/farmprobe/chat',
          'FAILED',
          e.toString(),
        );
        //
      }
      clearController();
    }
  }

  Future<void> audioChatWithBot({required String filePath}) async {
    final String startTime = parseDateTimeToTime();
    if (selectedLanguage!.languageKey != "eng") {
      await audioChatWithBotOtherLang(filePath: filePath);
    } else {
      if (filePath.isNotEmpty) {
        _chats[selectedSession!.sessionId!]!.insert(
          0,
          ChatModel(
            chatTime: parseDateTimeToTime(),
            isNewChat: true,
            startTime: startTime,
            question: filePath,
            isAudio: true,
            audioPath: filePath,
            sessionId: selectedSession!.sessionId,
          ),
        );
        notifyListeners();
        try {
          final bool isIos = getPlatForm();
          final resp = isIos
              ? await farmAssistanceRepository.audioChatWithBotFileMethod(
                  sessionId: selectedSession!.sessionId!,
                  filePath: filePath,
                  language: selectedLanguage!.languageKey!,
                )
              : await farmAssistanceRepository.audioChatWithBot(
                  sessionId: selectedSession!.sessionId!,
                  filePath: filePath,
                  language: selectedLanguage!.languageKey!,
                );
          if (resp.hasError()) {
            snackBarMsg(
              resp.error?.message ?? unableToContinue,
            );
            _chats[selectedSession!.sessionId]!.removeAt(0);
          } else {
            _chats[selectedSession!.sessionId]![0] = ChatModel(
              chatTime: parseDateTimeToTime(),
              startTime: startTime,
              question: filePath,
              isAudio: true,
              sessionId: selectedSession!.sessionId,
              answer: resp.response["message"],
              transcribeText: resp.response["transcribe_text"],
              translateText: resp.response["translate_text"],
            );
            final bool isNewChat = userSessionDatas
                .firstWhere(
                  (element) => element.sessionId == selectedSession!.sessionId,
                )
                .isNewChat!;

            if (isNewChat) {
              userSessionDatas
                  .firstWhere(
                    (element) =>
                        element.sessionId == selectedSession!.sessionId,
                  )
                  .name = resp.response["sessionName"];
            }
          }
        } catch (e) {
          _chats[selectedSession!.sessionId]!.removeAt(0);
          _pandora.logAPIEvent(
            'audio chat',
            '$baseUrl/farmprobe/chat',
            'FAILED',
            e.toString(),
          );
          //
        }
      }
      notifyListeners();
    }
  }

  Future<void> audioChatWithBotOtherLang({required String filePath}) async {
    final String startTime = parseDateTimeToTime();
    if (filePath.isNotEmpty) {
      _chats[selectedSession!.sessionId!]!.insert(
        0,
        ChatModel(
          chatTime: parseDateTimeToTime(),
          isNewChat: true,
          question: filePath,
          startTime: startTime,
          isAudio: true,
          audioPath: filePath,
          sessionId: selectedSession!.sessionId,
        ),
      );
      notifyListeners();
      try {
        final bool isIos = getPlatForm();
        final resp = isIos
            ? await farmAssistanceRepository
                .audioChatWithBotOtherLanguageFileMethod(
                sessionId: selectedSession!.sessionId!,
                filePath: filePath,
                language: selectedLanguage!.languageKey!,
              )
            : await farmAssistanceRepository.audioChatWithBotOtherLanguage(
                sessionId: selectedSession!.sessionId!,
                filePath: filePath,
                language: selectedLanguage!.languageKey!,
              );
        if (resp.hasError()) {
          snackBarMsg(
            resp.error?.message ?? unableToContinue,
          );
          _chats[selectedSession!.sessionId]!.removeAt(0);
        } else {
          chatController =
              TextEditingController(text: resp.response["message"]);
          if (kIsWeb) {
            await OneContext().showDialog(
              builder: (context) {
                return PreviewTextDialog(
                  controller: chatController,
                  onTapSend: () {
                    audioComplete(
                      text: chatController.text,
                      filePath: filePath,
                    );
                  },
                );
              },
            );
          } else {
            await previewTextDialog(
              controller: chatController,
              onTapSend: () {
                audioComplete(
                  text: chatController.text,
                  filePath: filePath,
                );
              },
            );
          }

          chatController.clear();
        }
      } catch (e) {
        _chats[selectedSession!.sessionId]!.removeAt(0);
        _pandora.logAPIEvent(
          'audio-chat other languages',
          '$baseUrl/farmprobe/chat',
          'FAILED',
          e.toString(),
        );
        //
      }
      notifyListeners();
    }
  }

  Future<void> audioComplete({
    required String text,
    required String filePath,
  }) async {
    final String startTime = parseDateTimeToTime();
    if (text.isNotEmpty) {
      try {
        final resp = await farmAssistanceRepository.completeChatWithBot(
          sessionId: selectedSession!.sessionId!,
          text: text,
          language: selectedLanguage!.languageKey!,
        );
        if (resp.hasError()) {
          snackBarMsg(
            resp.error?.message ?? unableToContinue,
          );
          _chats[selectedSession!.sessionId]!.removeAt(0);
        } else {
          _chats[selectedSession!.sessionId]![0] = ChatModel(
            chatTime: parseDateTimeToTime(),
            question: filePath,
            startTime: startTime,
            isAudio: true,
            sessionId: selectedSession!.sessionId,
            answer: resp.response["message"],
            transcribeText: resp.response["transcribe_text"] ?? "",
            translateText: resp.response["translate_text"] ?? "",
          );
          final bool isNewChat = userSessionDatas
              .firstWhere(
                (element) => element.sessionId == selectedSession!.sessionId,
              )
              .isNewChat!;

          if (isNewChat) {
            userSessionDatas
                .firstWhere(
                  (element) => element.sessionId == selectedSession!.sessionId,
                )
                .name = resp.response["sessionName"];
          }
        }
      } catch (e) {
        _chats[selectedSession!.sessionId]!.removeAt(0);
        _pandora.logAPIEvent(
          'audio-chat- other languages confirm translation ',
          '$baseUrl/farmprobe/chat',
          'FAILED',
          e.toString(),
        );
        //
      }
    }
    notifyListeners();
  }
}

String parseDateTimeToTime() {
  // Parse the datetime string
  final String dateTimeString = DateTime.now().toString();
  final DateTime dateTime = DateTime.parse(dateTimeString);
  // Format the DateTime as a 24-hour time with minutes
  final String formattedTime = DateFormat('HH:mm').format(dateTime);

  return formattedTime;
}

bool getPlatForm() {
  if (kIsWeb) {
    return false;
  } else {
    return Platform.isIOS;
  }
}
