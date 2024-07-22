// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Meal {
  final String meal_name;
  final int time_hours;
  final int time_minutes;
  final double total_calories;
  final String image_url;
  final String date;
  final String? totalCalories;
  final List<Map<String, dynamic>> ingredients;
  Meal({
    required this.meal_name,
    required this.time_hours,
    required this.time_minutes,
    required this.total_calories,
    required this.image_url,
    required this.date,
    this.totalCalories,
    required this.ingredients,
  });


  Meal copyWith({
    String? meal_name,
    int? time_hours,
    int? time_minutes,
    double? total_calories,
    String? image_url,
    String? date,
    String? totalCalories,
    List<Map<String, dynamic>>? ingredients,
  }) {
    return Meal(
      meal_name: meal_name ?? this.meal_name,
      time_hours: time_hours ?? this.time_hours,
      time_minutes: time_minutes ?? this.time_minutes,
      total_calories: total_calories ?? this.total_calories,
      image_url: image_url ?? this.image_url,
      date: date ?? this.date,
      totalCalories: totalCalories ?? this.totalCalories,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'meal_name': meal_name,
      'time_hours': time_hours,
      'time_minutes': time_minutes,
      'total_calories': total_calories,
      'image_url': image_url,
      'date': date,
      'totalCalories': totalCalories,
      'ingredients': ingredients,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      meal_name: map['meal_name'] as String,
      time_hours: map['time_hours'] as int,
      time_minutes: map['time_minutes'] as int,
      total_calories: map['total_calories'] as double,
      image_url: map['image_url'] as String,
      date: map['date'] as String,
      totalCalories: map['totalCalories'] != null ? map['totalCalories'] as String : null,
      ingredients: List<Map<String, dynamic>>.from((map['ingredients'] as List).map<Map<String, dynamic>>((x) => x,),),
    );
  }

  String toJson() => json.encode(toMap());

  factory Meal.fromJson(Map<String, dynamic> json) => Meal.fromMap(json);

  @override
  String toString() {
    return 'Meal(meal_name: $meal_name, time_hours: $time_hours, time_minutes: $time_minutes, total_calories: $total_calories, image_url: $image_url, date: $date, totalCalories: $totalCalories, ingredients: $ingredients)';
  }

  @override
  bool operator ==(covariant Meal other) {
    if (identical(this, other)) return true;
  
    return 
      other.meal_name == meal_name &&
      other.time_hours == time_hours &&
      other.time_minutes == time_minutes &&
      other.total_calories == total_calories &&
      other.image_url == image_url &&
      other.date == date &&
      other.totalCalories == totalCalories &&
      listEquals(other.ingredients, ingredients);
  }

  @override
  int get hashCode {
    return meal_name.hashCode ^
      time_hours.hashCode ^
      time_minutes.hashCode ^
      total_calories.hashCode ^
      image_url.hashCode ^
      date.hashCode ^
      totalCalories.hashCode ^
      ingredients.hashCode;
  }
}
