import 'package:dart_utilities/mixins/index.dart';

abstract class JsonModel with JsonMixin {
  JsonModel();

  JsonModel.fromJson(String opts) {
    this.fromJson(opts);
  }

  JsonModel.fromEntries(Map<String, dynamic> opts) {
    this.fromEntries(opts);
  }

  isIdentical(Object o) {
    return identical(this, o) || (o.runtimeType == this.runtimeType);
  }
}
