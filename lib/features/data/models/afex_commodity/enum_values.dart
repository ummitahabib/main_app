//enums values

class EnumValues<T> {
  Map<String, T>? map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    return reverseMap;
  }
}
