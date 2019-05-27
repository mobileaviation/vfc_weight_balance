// To parse this JSON data, do
//
//     final property = propertyFromJson(jsonString);

import 'dart:convert';

Property propertyFromJson(String str) => Property.fromJson(json.decode(str));

String propertyToJson(Property data) => json.encode(data.toJson());

class Property {
  int id;
  String field;
  int intValue;
  bool boolValue;
  String textValue;

  Property({
    this.id,
    this.field,
    this.intValue,
    this.boolValue,
    this.textValue,
  });

  factory Property.fromJson(Map<String, dynamic> json) => new Property(
    id: json["id"],
    field: json["field"],
    intValue: json["int_value"],
    boolValue: (json["bool_value"]==0) ? false : true,
    textValue: json["text_value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "field": field,
    "int_value": intValue,
    "bool_value": boolValue,
    "text_value": textValue,
  };
}


