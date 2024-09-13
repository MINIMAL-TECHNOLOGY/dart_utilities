import 'dart:convert';

class JSON {
  static String stringify(Object input) {
    return jsonEncode(input);
  }

  /* static parse(String input) {
    return JsonDecoder((key, value) {
      final valueType =
          MirrorSystem.getName(reflect(value).type.simpleName).toLowerCase();

      if (valueType.endsWith('map')) {
        return Map.from(value as Map).map((key, value) {
          return MapEntry(key as String, value as Object);
        });
      }

      if (valueType.endsWith('set')) {
        return Set.from(value as Set).map((value) {
          return value as Object;
        }).toSet();
      }

      if (valueType.endsWith('list')) {
        return List.from(value as List).map((value) {
          return value as Object;
        }).toList();
      }

      return value;
    }).convert(input);
  } */

  static Map<String, dynamic> parse(String input) {
    return jsonDecode(input);
  }
}
