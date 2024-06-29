// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Meal {
  final String name;
  final int totalCalories;
  final String mealImage;
  final DateTime date;
  final List<Map<String, dynamic>> mealIngredients;

  Meal({
    required this.name,
    required this.totalCalories,
    required this.mealImage,
    required this.date,
    required this.mealIngredients,
  });

  Meal copyWith({
    String? name,
    int? totalCalories,
    String? mealImage,
    String? date,
    List<Map<String, dynamic>>? mealIngredients,
  }) {
    return Meal(
      name: name ?? this.name,
      totalCalories: totalCalories ?? this.totalCalories,
      mealImage: mealImage ?? this.mealImage,
      date: date as DateTime? ?? this.date,
      mealIngredients: mealIngredients ?? this.mealIngredients,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'totalCalories': totalCalories,
      'mealImage': mealImage,
      'date': date,
      'mealIngredients': mealIngredients,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      name: map['name'] as String,
      totalCalories: map['totalCalories'] as int,
      mealImage: map['mealImage'] as String,
      date: map['date'] as DateTime,
      mealIngredients: List<Map<String, dynamic>>.from((map['mealIngredients'] as List<Map<String, dynamic>>).map<Map<String, dynamic>>((x) => x,),),
    );
  }

  String toJson() => json.encode(toMap());

  factory Meal.fromJson(String source) => Meal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Meal(name: $name, totalCalories: $totalCalories, mealImage: $mealImage, date: $date, mealIngredients: $mealIngredients)';
  }

  @override
  bool operator ==(covariant Meal other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.totalCalories == totalCalories &&
      other.mealImage == mealImage &&
      other.date == date &&
      listEquals(other.mealIngredients, mealIngredients);
  }

  @override
  int get hashCode {
    return name.hashCode ^
      totalCalories.hashCode ^
      mealImage.hashCode ^
      date.hashCode ^
      mealIngredients.hashCode;
  }
}
