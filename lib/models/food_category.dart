import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:wasfat_web/models/dish.dart';

class FoodCategory {
  final String id;
  final String name;
  final String imageUrl;
  final int priority;
  final List<Dish>? dishes;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.priority,
    this.dishes,
  });

  FoodCategory copyWith({
    String? id,
    String? name,
    String? imageUrl,
    int? priority,
    List<Dish>? dishes,
  }) {
    return FoodCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      priority: priority ?? this.priority,
      dishes: dishes ?? this.dishes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'priority': priority,
      'dishes': dishes?.map((x) => x.toMap()).toList(),
    };
  }

  factory FoodCategory.fromMap(Map<String, dynamic> map) {
    final dishes = map['dishes'] != null
        ? List<Dish>.from(map['dishes']?.map((x) => Dish.fromMap(x)))
        : null;
    return FoodCategory(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      priority: map['priority'],
      dishes: dishes,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodCategory.fromJson(String source) =>
      FoodCategory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FoodCategory(id: $id, name: $name, imageUrl: $imageUrl, priority: $priority, dishes: $dishes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FoodCategory &&
        other.id == id &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        other.priority == priority &&
        listEquals(other.dishes, dishes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        imageUrl.hashCode ^
        priority.hashCode ^
        dishes.hashCode;
  }
}
