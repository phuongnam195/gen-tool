import 'dart:convert';

import 'package:recase/recase.dart';

import 'interface.dart';

class TBEMJsonToModelsConverter implements JsonToModelsConverter {
  @override
  String convert(String input, String rootName) {
    input = input.trim();

    String output = '';

    output += "import 'package:json_annotation/json_annotation.dart';\n";
    output += "import 'package:tbox_event_manager_flutter/core/network/models/api_error.dart';\n";
    output += "import 'package:tbox_event_manager_flutter/core/network/models/base_response.dart';\n";
    output += '\n';
    output += "part '${rootName.snakeCase}_response.g.dart';\n";
    output += _buildRootClassCode(rootName);
    output += _buildClassCode('${rootName.pascalCase}Response', Map.from(jsonDecode(input)));

    return output;
  }

  String _buildRootClassCode(String rootName) {
    String result = '';

    final className = '${rootName.pascalCase}Response';

    result += '\n';
    result += '@JsonSerializable(explicitToJson: true)\n';
    result += 'class $className extends BaseDataResponse {\n';
    result += '  $className? data;\n';
    result += '\n';
    result +=
        '  $className({this.data, bool? success, String? message, ApiError? err, int? status_code,}) : super(success, message, err, status_code);\n';
    result += '\n';
    result += '  factory $className.fromJson(Map<String, dynamic> json) => _\$${className}FromJson(json);\n';
    result += '\n';
    result += '  Map<String, dynamic> toJson() => _\$${className}ToJson(this);\n';
    result += '}\n';

    return result;
  }

  String _buildClassCode(String className, Map<String, dynamic> map) {
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
        result += '  final String? $fieldName;\n';
      } else if (value is int) {
        result += '  final int? $fieldName;\n';
      } else if (value is double) {
        result += '  final double? $fieldName;\n';
      } else if (value is bool) {
        result += '  final bool? $fieldName;\n';
      } else if (value is List) {
        // TODO: chưa hẳn phần tử đầu tiên có đủ thuộc tính
        if (value.first is Map) {
          String elementType = fieldName;
          if (elementType[elementType.length - 1] == 's') {
            elementType = elementType.substring(0, elementType.length - 1);
          }
          elementType = '${elementType.pascalCase}Response';
          result += '  final List<$elementType>? $fieldName;\n';
          final elementClassCode = _buildClassCode(elementType, value.first);
          listSubClassCode.add(elementClassCode);
        } else if (value.first is String) {
          result += '  final List<String>? $fieldName;\n';
        } else if (value.first is int) {
          result += '  final List<int>? $fieldName;\n';
        } else if (value.first is double) {
          result += '  final List<double>? $fieldName;\n';
        } else if (value.first is bool) {
          result += '  final List<bool>? $fieldName;\n';
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
    result += '  $className({${listFieldName.map((e) => 'this.$e, ').toList().join(', ')}});\n';
    result += '\n';
    result += '  factory $className.fromJson(Map<String, dynamic> json) => _\$${className}FromJson(json);\n';
    result += '\n';
    result += '  Map<String, dynamic> toJson() => _\$${className}ToJson(this);\n';
    result += '}\n';

    result += listSubClassCode.join();

    return result;
  }
}
