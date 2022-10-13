import 'package:gen_tool/converter/json_to_models/interface.dart';

class J2M {
  final String key;
  final String name;
  final String shortName;
  final JsonToModelsConverter converter;

  J2M({
    required this.key,
    required this.name,
    required this.shortName,
    required this.converter,
  });
}
