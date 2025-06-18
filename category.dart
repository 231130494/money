import 'package:flutter/material.dart';

class Category {
  int? id;
  String name;
  String type;
  int? color;

  Category({this.id, required this.name, required this.type, this.color});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'color': color,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      color: map['color'],
    );
  }

  Color get flutterColor => color != null ? Color(color!) : Colors.grey;

  set flutterColor(Color value) {
    color = value.value;
  }
}