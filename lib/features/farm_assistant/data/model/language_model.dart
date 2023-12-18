class LanguageModel {
  String? languageKey;
  String? languageName;

  LanguageModel.fromjson({required Map<String, dynamic> languageData}) {
    languageKey = languageData["key"];
    languageName = languageData["name"];
  }

  @override
  String toString() {
    final Map<String, dynamic> data = {
      "languageKey": languageKey,
      "languageName": languageName,
    };
    return data.toString();
  }
}
