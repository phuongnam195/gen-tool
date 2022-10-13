import 'dart:convert';

import 'package:recase/recase.dart';

import 'interface.dart';

class LTJsonToModelsConverter implements JsonToModelsConverter {
  @override
  String convert(String input, String rootName) {
    input = input.trim();

    String output = '';

    output += "import 'package:json_annotation/json_annotation.dart';\n";
    output += "import 'package:let_tutor/core/base_model.dart';\n";
    output += '\n';
    output += "part '${rootName.snakeCase}.g.dart';\n";
    output += _buildClassCode(rootName.pascalCase, Map.from(jsonDecode(input)));

    return output;
  }

  String _buildClassCode(String className, Map<String, dynamic> map) {
    String result = '';

    List<String> listFieldName = [];
    List<String> listSubClassCode = [];

    bool isExtends = false;

    if (map.containsKey('createdAt')) {
      isExtends = true;
      map.remove('createdAt');
      map.remove('updatedAt');
      map.remove('deletedAt');
    }
    result += '\n';
    result += '@JsonSerializable()\n';
    result += 'class $className ${isExtends ? 'extends BaseModel ' : ''}{\n';
    for (var key in map.keys) {
      final value = map[key];
      var fieldName = key.camelCase;
      listFieldName.add(fieldName);
      if (key != key.camelCase) {
        result += "  @JsonKey(name: '$key')\n";
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
        if (value.isEmpty) {
          result += '  final List<dynamic>? $fieldName;\n';
        }
        // TODO: chưa hẳn phần tử đầu tiên có đủ thuộc tính
        else if (value.first is Map) {
          String elementType = fieldName;
          if (elementType[elementType.length - 1] == 's') {
            elementType = elementType.substring(0, elementType.length - 1);
          }
          elementType = elementType.pascalCase;
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
        type = type.pascalCase;
        result += '  final $type? $fieldName;\n';
        final elementClassCode = _buildClassCode(type, valueMap);
        listSubClassCode.add(elementClassCode);
      }
    }
    result += '\n';
    result += '  $className({${listFieldName.map((e) => 'this.$e').toList().join(', ')},';
    if (isExtends) {
      result +=
          'DateTime? createdAt, DateTime? updatedAt, DateTime? deletedAt,}) : super(createdAt,updatedAt,deletedAt,);\n';
    } else {
      result += '});\n';
    }
    result += '\n';
    result += '  factory $className.fromJson(Map<String, dynamic> json) => _\$${className}FromJson(json);\n';
    result += '\n';
    result += '  Map<String, dynamic> toJson() => _\$${className}ToJson(this);\n';
    result += '}\n';

    result += listSubClassCode.join();

    return result;
  }
}
