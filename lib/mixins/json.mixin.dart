import 'dart:mirrors';

import 'package:df_utilities/utilities/index.dart';

final RAW_TYPES = <Type>{String, int, double, bool, Null, Object};

mixin JsonMixin {
  getValue<T>(dynamic reflectee, Symbol key, dynamic value) {
    final r = reflect(reflectee);

    var valueType = value.runtimeType;
    if (RAW_TYPES.contains(valueType)) {
      return value;
    }

    var def = r.type.declarations[key];
    if (def == null || def is! VariableMirror) {
      return null;
    }

    var rType = def.type;
    if (rType is! ClassMirror) {
      return null;
    }

    final objectType = MirrorSystem.getName(rType.simpleName).toString();
    switch (objectType.toLowerCase()) {
      case 'map' || 'set' || 'list':
        break;
      default:
        return rType.newInstance(Symbol('fromEntries'), [value]).reflectee;
    }
  }

  parseObject(dynamic reflectee, Map<String, dynamic> parsed) {
    final r = reflect(reflectee);

    final entries = parsed.entries;
    for (final entry in entries) {
      final key = Symbol(entry.key);

      final propValue = this.getValue(reflectee, key, entry.value);
      if (propValue == null) {
        continue;
      }

      r.setField(Symbol(entry.key), propValue);
    }
  }

  fromEntries(Map<String, dynamic> entries) {
    this.parseObject(this, entries);
  }

  fromJson(String opts) {
    final parsed = JSON.parse(opts);
    this.fromEntries(parsed);
  }

  Map<String, dynamic> toJson() {
    var r = reflect(this);
    var defs = r.type.declarations;

    final rs = <String, dynamic>{};
    for (var def in defs.values) {
      if (def is! VariableMirror) {
        continue;
      }

      final varName = MirrorSystem.getName(def.simpleName).toString();

      rs.putIfAbsent(
        varName,
        () {
          final returnType =
              MirrorSystem.getName(def.type.simpleName).toString();
          final returnValue = r.getField(def.simpleName).reflectee;

          switch (returnType.toLowerCase()) {
            case 'set':
              return returnValue.toList();
            default:
              return returnValue;
          }
        },
      );
    }

    return rs;
  }

  @override
  String toString() {
    return JSON.stringify(this);
  }
}
