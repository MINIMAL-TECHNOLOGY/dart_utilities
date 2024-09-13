import 'package:collection/collection.dart';
import 'package:dart_utilities/dart-utilities.dart';
import 'package:dart_utilities/models/index.dart';
import 'package:test/test.dart';

class AuthToken extends JsonModel {
  String? type;
  String? value;

  AuthToken(this.type, this.value);

  AuthToken.fromJson(String opts) : super.fromJson(opts);
  AuthToken.fromEntries(Map<String, dynamic> opts) : super.fromEntries(opts);

  @override
  bool operator ==(Object o) {
    return super.isIdentical(o) &&
        o is AuthToken &&
        o.type == this.type &&
        o.value == this.value;
  }
}

class Role extends JsonModel {
  String name = '';

  Role(this.name);

  Role.fromJson(String opts) : super.fromJson(opts);
  Role.fromEntries(Map<String, dynamic> opts) : super.fromEntries(opts);

  @override
  bool operator ==(Object o) {
    return super.isIdentical(o) && o is Role && o.name == this.name;
  }
}

class AuthRole extends JsonModel {
  String identifier = '';

  List<Role> roleList = [];
  Set<Role> roleSet = {};
  Map<String, Role> roleMap = {};

  AuthRole(this.identifier, this.roleList, this.roleSet, this.roleMap);

  AuthRole.fromJson(String opts) : super.fromJson(opts);
  AuthRole.fromEntries(Map<String, dynamic> opts) : super.fromEntries(opts) {
    this.roleList = List.from(opts['roleList']).map((el) {
      return Role(el['name']);
    }).toList();

    this.roleSet = Set.from(opts['roleSet']).map((el) {
      return Role(el['name']);
    }).toSet();

    this.roleMap = Map.from(opts['roleMap']).map((key, value) {
      return MapEntry(key, Role(value['name']));
    });
  }

  @override
  bool operator ==(Object o) {
    Function isEqual = const IterableEquality().equals;

    if (o is! AuthRole) {
      return false;
    }

    return super.isIdentical(o) &&
        o.identifier == this.identifier &&
        isEqual(o.roleList, this.roleList) &&
        isEqual(o.roleSet, this.roleSet);
  }
}

class Auth extends JsonModel {
  String username = '';
  String password = '';
  int? passcode;
  bool? isUse;

  AuthToken? token;
  AuthRole? roles;

  Auth(
    this.username,
    this.password,
    this.passcode,
    this.isUse,
    this.token,
    this.roles,
  );
  Auth.fromJson(String opts) : super.fromJson(opts);
  Auth.fromEntries(Map<String, Object> opts) : super.fromEntries(opts);

  @override
  bool operator ==(Object o) {
    print('hererererer');
    if (o is! Auth) {
      return false;
    }

    return this.isIdentical(o) &&
        o.username == this.username &&
        o.password == this.password &&
        o.passcode == this.passcode &&
        o.isUse == this.isUse &&
        o.token == this.token &&
        o.roles == this.roles;
  }
}

void main() {
  test('Stringify Object to Json', () {
    final expectedRs =
        '{"username":"tanphat199","password":"secret","passcode":123,"isUse":false,"token":{"type":"Bearer","value":"xxx"},"roles":{"identifier":"TEST_IDENTIFIER","roleList":[{"name":"r1"},{"name":"r2"}],"roleSet":[{"name":"r3"}],"roleMap":{"r4":{"name":"r4"},"r5":{"name":"r5"}}}}';

    final auth = Auth(
      'tanphat199',
      'secret',
      123,
      false,
      AuthToken('Bearer', 'xxx'),
      AuthRole(
        'TEST_IDENTIFIER',
        [Role('r1'), Role('r2')],
        {Role('r3')},
        {'r4': Role('r4'), 'r5': Role('r5')},
      ),
    );
    final stringified = JSON.stringify(auth);
    expect(stringified, expectedRs);
  });

  test('Parse Json to Object', () {
    final json =
        '{"username":"tanphat199","password":"secret","passcode":123,"isUse":false,"token":{"type":"Bearer","value":"xxx"},"roles":{"identifier":"TEST_IDENTIFIER","roleList":[{"name":"r1"},{"name":"r2"}],"roleSet":[{"name":"r3"}],"roleMap":{"r4":{"name":"r4"},"r5":{"name":"r5"}}}}';

    final auth = Auth(
      'tanphat199',
      'secret',
      123,
      false,
      AuthToken('Bearer', 'xxx'),
      AuthRole(
        'TEST_IDENTIFIER',
        [Role('r1'), Role('r2')],
        {Role('r3')},
        {'r4': Role('r4'), 'r5': Role('r5')},
      ),
    );
    final parsed = Auth.fromJson(json);

    expect(parsed == auth, true);
  });
}
