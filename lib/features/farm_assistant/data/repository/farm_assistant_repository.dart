import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:smat_crow/features/farm_assistant/data/model/chat_model.dart';
import 'package:smat_crow/features/farm_assistant/data/model/language_model.dart';
import 'package:smat_crow/features/farm_assistant/data/model/user_session_model.dart';
import 'package:smat_crow/features/organisation/data/models/request_res.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:universal_html/html.dart' as html;

Pandora _pandora = Pandora();
String baseUrl = ApiClient.farmProbe;
String farmProbe = ApiClient.farmProbe;

class FarmAssistanceRepository {
  Future<RequestRes> getSupportedLanguages() async {
    final String accessToken = await _pandora.getFromSharedPreferences("token");
    try {
      http.Response? response;
      response = await http.get(
        Uri.parse(
          "$farmProbe/farmprobe/supported-languages",
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> languageDataFromApi = data["response"]["message"];
        final List<LanguageModel> landuageDatas = languageDataFromApi
            .map(
              (e) => LanguageModel.fromjson(languageData: e),
            )
            .toList();
        return RequestRes(response: landuageDatas);
      } else {
        return RequestRes(response: []);
      }
    } catch (e) {
      _pandora.logAPIEvent(
        'supported-languages',
        '$farmProbe/farmprobe/supported-languages',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getUserSession() async {
    final String accessToken = await _pandora.getFromSharedPreferences("token");
    try {
      http.Response? response;
      response = await http.get(
        Uri.parse(
          "$farmProbe/farmprobe/user-sessions",
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> userSessionDataFromApi =
            data["response"]["message"];
        final List<USerSessionModel> userSessionDatas = userSessionDataFromApi
            .map(
              (e) => USerSessionModel.fromjson(userData: e),
            )
            .toList();
        return RequestRes(response: userSessionDatas);
      } else {
        return RequestRes(response: []);
      }
    } catch (e) {
      _pandora.logAPIEvent(
        'user-sessions',
        '$farmProbe/farmprobe/user-sessions',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getChatHistory({required String sessionId}) async {
    final String accessToken = await _pandora.getFromSharedPreferences("token");
    try {
      http.Response? response;
      response = await http.get(
        Uri.parse(
          "$farmProbe/farmprobe/session-history/$sessionId",
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final data = jsonDecode(response.body);
    
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> apichatData = data["response"]["message"];
        final List<ChatModel> chatDatas = apichatData.reversed
            .map(
              (e) => ChatModel.fromJson(chatData: e),
            )
            .toList();
        return RequestRes(response: chatDatas);
      } else {
        return RequestRes(response: []);
      }
    } catch (e) {
      _pandora.logAPIEvent(
        'session-history$sessionId',
        '$farmProbe/farmprobe/session-history/$sessionId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> deleteSession({required String sessionId}) async {
    final String accessToken = await _pandora.getFromSharedPreferences("token");
    try {
      http.Response? response;
      response = await http.delete(
        Uri.parse(
          "$farmProbe/farmprobe/delete-session/$sessionId",
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok) {
        if (data["response"]["status"] == HttpStatus.ok) {
          return RequestRes(
            response: data["response"]["message"],
          );
        }
      }
      return RequestRes(error: ErrorRes(message: data["response"]["message"]));
    } catch (e) {
      _pandora.logAPIEvent(
        'deleteSession',
        '$farmProbe/farmprobe/delete-session/$sessionId',
        'FAILED',
        e.toString(),
      );

      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> createSession() async {
    final String accessToken = await _pandora.getFromSharedPreferences("token");
    try {
      http.Response? response;
      response = await http.get(
        Uri.parse(
          "$farmProbe/farmprobe/create-session",
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok) {
        if (data["response"]["status"] == HttpStatus.ok) {
          return RequestRes(
            response: data["response"]["message"],
          );
        }
      }

      return RequestRes(error: ErrorRes(message: data["response"]["message"]));
    } catch (e) {
      _pandora.logAPIEvent(
        'create-session',
        '$farmProbe/farmprobe//create-session',
        'FAILED',
        e.toString(),
      );

      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> chatWithBot({
    required String sessionId,
    required String input,
  }) async {
    final String accessToken = await _pandora.getFromSharedPreferences("token");
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "$farmProbe/farmprobe/chat",
        ),
      ); // headers
      request.headers.addAll(<String, String>{
        'Authorization': "Bearer $accessToken",
      });
      request.fields.addAll(<String, String>{
        'session_id': sessionId,
        'input_text': input,
      });
      final response = await request.send();

      final responseData = await http.Response.fromStream(response);
      final data = jsonDecode(responseData.body);
      if (response.statusCode == HttpStatus.ok) {
        return RequestRes(
          response: {
            "message": data["response"]["message"],
            "sessionName": data["response"]["session_name"],
          },
        );
      }
      return RequestRes(error: ErrorRes(message: data["response"]["message"]));
    } catch (e) {
      _pandora.logAPIEvent(
        'chat',
        '$farmProbe/farmprobe/chat',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> audioChatWithBot({
    required String sessionId,
    required String filePath,
    required String language,
  }) async {
    final String accessToken = await _pandora.getFromSharedPreferences("token");
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "$farmProbe/farmprobe/chat",
        ),
      ); // headers
      request.headers.addAll(<String, String>{
        'Authorization': "Bearer $accessToken",
      });
      final String audioFile = await convertBlobUrlToBase64(filePath);

      request.fields.addAll(
        <String, String>{
          'session_id': sessionId,
          'audio64': audioFile,
          'lang': language,
        },
      );
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      final data = jsonDecode(responseData.body);
      if (response.statusCode == HttpStatus.ok) {
        final String blobUrl =
            await convertBase64UrlToBlobUrl(data["response"]["message"]);
        if (blobUrl == "") {
          return RequestRes(
            error: ErrorRes(
              message: cannotReadAudioFile,
            ),
          );
        }
        return RequestRes(
          response: {
            "message": blobUrl,
            "sessionName": data["response"]["session_name"],
            "translate_text": data["response"]["translate_text"],
            "transcribe_text": data["response"]["transcribe_text"],
          },
        );
      }
      return RequestRes(error: ErrorRes(message: data["response"]["message"]));
    } catch (e) {
      _pandora.logAPIEvent(
        'audio chat',
        '$farmProbe/farmprobe/chat',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> audioChatWithBotFileMethod({
    required String sessionId,
    required String filePath,
    required String language,
  }) async {
    final String accessToken = await _pandora.getFromSharedPreferences("token");
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "$farmProbe/farmprobe/chat",
        ),
      ); // headers
      request.headers.addAll(<String, String>{
        'Authorization': "Bearer $accessToken",
      });
      request.fields.addAll(
        <String, String>{
          'session_id': sessionId,
          'lang': language,
        },
      );

      final multipartFile = await http.MultipartFile.fromPath(
        'audioFile',
        filePath,
        contentType: MediaType('audio', 'm4a'),
      );
      request.files.add(multipartFile);
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      final data = jsonDecode(responseData.body);

      if (response.statusCode == HttpStatus.ok) {
        final String blobUrl =
            await convertBase64UrlToBlobUrl(data["response"]["message"]);
        if (blobUrl == "") {
          return RequestRes(
            error: ErrorRes(
              message: cannotReadAudioFile,
            ),
          );
        }
        return RequestRes(
          response: {
            "message": blobUrl,
            "sessionName": data["response"]["session_name"],
            "translate_text": data["response"]["translate_text"],
            "transcribe_text": data["response"]["transcribe_text"],
          },
        );
      }
      return RequestRes(error: ErrorRes(message: data["response"]["message"]));
    } catch (e) {
      print(e);
      _pandora.logAPIEvent(
        'audio chat',
        '$farmProbe/farmprobe/chat',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> audioChatWithBotOtherLanguage({
    required String sessionId,
    required String filePath,
    required String language,
  }) async {
    final String accessToken = await _pandora.getFromSharedPreferences("token");
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "$farmProbe/farmprobe/chat",
        ),
      ); // headers
      request.headers.addAll(<String, String>{
        'Authorization': "Bearer $accessToken",
        'Accept-Charset': 'utf-8',
      });
      final String audioFile = await convertBlobUrlToBase64(filePath);
      request.fields.addAll(
        <String, String>{
          'session_id': sessionId,
          'audio64': audioFile,
          'lang': language,
        },
      );
      final response = await request.send();

      final responseData = await http.Response.fromStream(response);

      final data = jsonDecode(utf8.decode(responseData.bodyBytes));

      if (response.statusCode == HttpStatus.ok) {
        final String returnedString = data["response"]["message"];
        return RequestRes(
          response: {
            "message": returnedString,
            "sessionName": data["response"]["session_name"],
          },
        );
      }
      return RequestRes(error: ErrorRes(message: data["response"]["message"]));
    } catch (e) {
      _pandora.logAPIEvent(
        'audio-chat other languages',
        '$farmProbe/farmprobe/chat',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> audioChatWithBotOtherLanguageFileMethod({
    required String sessionId,
    required String filePath,
    required String language,
  }) async {
    final String accessToken = await _pandora.getFromSharedPreferences("token");
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "$farmProbe/farmprobe/chat",
        ),
      ); // headers
      request.headers.addAll(<String, String>{
        'Authorization': "Bearer $accessToken",
        'Accept-Charset': 'utf-8',
      });
      request.fields.addAll(
        <String, String>{
          'session_id': sessionId,
          'lang': language,
        },
      );
      final multipartFile = await http.MultipartFile.fromPath(
        'audioFile',
        filePath,
        contentType: MediaType('audio', 'm4a'),
      );
      request.files.add(multipartFile);
      final response = await request.send();

      final responseData = await http.Response.fromStream(response);
      final data = jsonDecode(utf8.decode(responseData.bodyBytes));
      if (response.statusCode == HttpStatus.ok) {
        final String returnedString = data["response"]["message"];
        return RequestRes(
          response: {
            "message": returnedString,
            "sessionName": data["response"]["session_name"],
          },
        );
      }
      return RequestRes(error: ErrorRes(message: data["response"]["message"]));
    } catch (e) {
      _pandora.logAPIEvent(
        'audio-chat other languages',
        '$farmProbe/farmprobe/chat',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> completeChatWithBot({
    required String sessionId,
    required String text,
    required String language,
  }) async {
    final String accessToken = await _pandora.getFromSharedPreferences("token");
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "$farmProbe/farmprobe/chat",
        ),
      ); // headers
      request.headers.addAll(<String, String>{
        'Authorization': "Bearer $accessToken",
        'Accept-Charset': 'utf-8',
      });
      request.fields.addAll(
        <String, String>{
          'session_id': sessionId,
          'input_text': text,
          'lang': language,
          'translate_text': 'true'
        },
      );

      final response = await request.send();

      final responseData = await http.Response.fromStream(response);
      final data = jsonDecode(utf8.decode(responseData.bodyBytes));

      if (response.statusCode == HttpStatus.ok) {
        final String blobUrl =
            await convertBase64UrlToBlobUrl(data["response"]["message"]);
        if (blobUrl == "") {
          return RequestRes(
            error: ErrorRes(
              message: cannotReadAudioFile,
            ),
          );
        }
        return RequestRes(
          response: {
            "message": blobUrl,
            "sessionName": data["response"]["session_name"],
            "translate_text": data["response"]["translate_text"],
            "transcribe_text": data["response"]["transcribe_text"],
          },
        );
      }
      return RequestRes(error: ErrorRes(message: data["response"]["message"]));
    } catch (e) {
      _pandora.logAPIEvent(
        'audio-chat- other languages confirm translation ',
        '$farmProbe/farmprobe/chat',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }
}

Future<String> convertBlobUrlToBase64(String blobUrl) async {
  if (kIsWeb) {
    try {
      final response =
          await html.HttpRequest.request(blobUrl, responseType: 'blob');
      final blob = response.response as html.Blob;

      // Convert the Blob to a Uint8List
      final reader = html.FileReader();
      reader.readAsArrayBuffer(blob);
      await reader.onLoad.first;

      final uint8List = Uint8List.fromList(reader.result as List<int>);

      // Encode the Uint8List as a Base64 string
      final base64String = base64Encode(uint8List);
      return base64String;
    } catch (e) {
      return emptyString;
    }
  } else {
    final String filePath = blobUrl;
    final File audioFile = File(filePath);
    final Uint8List audioBytes = await audioFile.readAsBytes();
    final String base64string = base64.encode(audioBytes);
    return base64string;
  }
}

Future<String> convertBase64UrlToBlobUrl(String base64Url) async {
  if (kIsWeb) {
    // Decode the Base64 data into Uint8List
    final Uint8List binaryData = Uint8List.fromList(base64Decode(base64Url));
    // Create a Blob from the binary data
    final blob = html.Blob([binaryData]);
    // Generate a Blob URL from the Blob object
    final blobUrl = html.Url.createObjectUrlFromBlob(blob);
    return blobUrl;
  } else {
    try {
      final Uint8List decodedbytes = base64.decode(base64Url);
      final path = await getApplicationDocumentsDirectory();
      final String dir = p.join(
        path.path,
        'audio_${DateTime.now().millisecondsSinceEpoch}.wav',
      );
      final File decodedaudfile = await File(dir).create(recursive: true);
      await decodedaudfile.writeAsBytes(decodedbytes);
      return decodedaudfile.path;
    } catch (e) {
      return "";
    }
  }
}

String convertFilePath(String filePath) {
  if (filePath.startsWith('file:///')) {
    final String returnFile = filePath.replaceAll('file:///', '');

    return returnFile;
  } else {
    return filePath;
  }
}

String removeTrailingChars(String base64String, String charsToRemove) {
  if (base64String.endsWith(charsToRemove)) {
    final String newString = base64String.substring(
      0,
      base64String.length - charsToRemove.length,
    );
    return newString;
  } else {
    return base64String;
  }
}
