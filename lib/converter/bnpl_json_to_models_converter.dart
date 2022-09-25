import 'dart:convert';

import 'package:recase/recase.dart';

class BNPLJsonToModelsConverter {
  static String convert(String input, String rootName) {
    input = input.trim();

    String output = '';

    output += "import 'package:json_annotation/json_annotation.dart';\n";
    output += '\n';
    output += "part '${rootName.snakeCase}_response.g.dart';\n";
    output += _buildRootClassCode(rootName);
    output += _buildClassCode('${rootName.pascalCase}DataResponse', Map.from(jsonDecode(input)));

    return output;
  }

  static String _buildRootClassCode(String rootName) {
    String result = '';

    final className = '${rootName.pascalCase}Response';

    result += '\n';
    result += '@JsonSerializable(explicitToJson: true)\n';
    result += 'class $className extends BaseDataResponse {\n';
    result += '  ${className}DataResponse? data;\n';
    result += '\n';
    result += '  $className({code, message, this.data}) : super(code: code, message: message);\n';
    result += '\n';
    result += '  factory $className.fromJson(Map<String, dynamic> json) => _\$${className}FromJson(json);\n';
    result += '\n';
    result += '  Map<String, dynamic> toJson() => _\$${className}ToJson(this);\n';
    result += '}\n';

    return result;
  }

  static String _buildClassCode(String className, Map<String, dynamic> map) {
    String result = '';

    List<String> listFieldName = [];
    List<String> listSubClassCode = [];

    result += '\n';
    result += '@JsonSerializable(explicitToJson: true)\n';
    result += 'class $className {\n';
    for (var key in map.keys) {
      final value = map[key];
      var fieldName = key.camelCase;
      listFieldName.add(fieldName);
      if (key.snakeCase.contains('_')) {
        result += "  @JsonKey(name: '${fieldName.snakeCase}')\n";
      }
      if (value is String) {
        result += '  String? $fieldName;\n';
      } else if (value is int) {
        result += '  int? $fieldName;\n';
      } else if (value is double) {
        result += '  double? $fieldName;\n';
      } else if (value is bool) {
        result += '  bool? $fieldName;\n';
      } else if (value is List) {
        // TODO: chưa hẳn phần tử đầu tiên có đủ thuộc tính
        if (value.first is Map) {
          String elementType = fieldName;
          if (elementType[elementType.length - 1] == 's') {
            elementType = elementType.substring(0, elementType.length - 1);
          }
          elementType = '${elementType.pascalCase}Response';
          result += '  List<$elementType>? $fieldName;\n';
          final elementClassCode = _buildClassCode(elementType, value.first);
          listSubClassCode.add(elementClassCode);
        } else if (value.first is String) {
          result += '  List<String>? $fieldName;\n';
        } else if (value.first is int) {
          result += '  List<int>? $fieldName;\n';
        } else if (value.first is double) {
          result += '  List<double>? $fieldName;\n';
        } else if (value.first is bool) {
          result += '  List<bool>? $fieldName;\n';
        }
      } else {
        Map<String, dynamic> valueMap = Map.from(value);
        String type = fieldName;
        type = '${type.pascalCase}Response';
        result += '  $type? $fieldName;\n';
        final elementClassCode = _buildClassCode(type, valueMap);
        listSubClassCode.add(elementClassCode);
      }
    }
    result += '\n';
    result += '  $className({${listFieldName.map((e) => 'this.$e').toList().join(', ')}});\n';
    result += '\n';
    result += '  factory $className.fromJson(Map<String, dynamic> json) => _\$${className}FromJson(json);\n';
    result += '\n';
    result += '  Map<String, dynamic> toJson() => _\$${className}ToJson(this);\n';
    result += '}\n';

    result += listSubClassCode.join();

    return result;
  }
}
