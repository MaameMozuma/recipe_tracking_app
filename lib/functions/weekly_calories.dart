import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// Function to get the week range for a given date
Map<String, String> getWeekDates(DateTime date) {
  DateTime sunday = date.subtract(Duration(days: date.weekday - 1));

  // Calculate the dates for each day of the week
  DateTime monday = sunday.add(Duration(days: 1));
  DateTime tuesday = sunday.add(Duration(days: 2));
  DateTime wednesday = sunday.add(Duration(days: 3));
  DateTime thursday = sunday.add(Duration(days: 4));
  DateTime friday = sunday.add(Duration(days: 5));
  DateTime saturday = sunday.add(Duration(days: 6));

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  String sundayStr = dateFormat.format(sunday);
  String mondayStr = dateFormat.format(monday);
  String tuesdayStr = dateFormat.format(tuesday);
  String wednesdayStr = dateFormat.format(wednesday);
  String thursdayStr = dateFormat.format(thursday);
  String fridayStr = dateFormat.format(friday);
  String saturdayStr = dateFormat.format(saturday);

  return {
    'Sunday': sundayStr,
    'Monday': mondayStr,
    'Tuesday': tuesdayStr,
    'Wednesday': wednesdayStr,
    'Thursday': thursdayStr,
    'Friday': fridayStr,
    'Saturday': saturdayStr,
  };
}

// Function to get the dates for the previous week relative to a given date
Map<String, String> getPreviousWeek(DateTime date) {
  // Calculate the date one week ago
  DateTime previousWeekDate = date.subtract(Duration(days: 7));
  // Get the week dates for the previous week
  return getWeekDates(previousWeekDate);
}

// Function to get the dates for the next week relative to a given date
Map<String, String> getNextWeek(DateTime date) {
  // Calculate the date one week ahead
  DateTime nextWeekDate = date.add(Duration(days: 7));

  // Get the week dates for the next week
  return getWeekDates(nextWeekDate);
}

//Function to get this weeks total calories
Future<Map<String, dynamic>> getWeeksCalories(
    String date1,
    String date2,
    String date3,
    String date4,
    String date5,
    String date6,
    String date7) async {
  String userId = "user123";
  String baseUrl =
      "https://samuelandhenryapi.com/api/"; // Replace with actual API base URL

  List<String> dates = [date1, date2, date3, date4, date5, date6, date7];
  Map<String, dynamic> totalCalories = {};

  for (String date in dates) {
    String url = "${baseUrl}daily-meal-tracking";
    Map<String, String> payload = {
      "user_id": userId,
      "date": date,
    };

    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode(payload));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        dynamic total = 0;
        for (var meal in data['meals']) {
          total += meal['total_calories'];
        }
        totalCalories[date] = total;
      } else {
        totalCalories[date] = "Error fetching data";
      }
    } catch (e) {
      totalCalories[date] = "Error: $e";
    }
  }
  return totalCalories;
}
