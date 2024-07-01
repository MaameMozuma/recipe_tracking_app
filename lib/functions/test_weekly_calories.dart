// Future<void> main() async {
//   DateTime inputDate =
//   DateTime(2024, 5, 4); // Example date: Tuesday, 4th May 2024
//
//   // Get dates for the previous week
//   Map<String, String> previousWeekDates = getPreviousWeek(inputDate);
//   print("Previous Week:");
//   previousWeekDates.forEach((day, date) {
//     print('$day: $date');
//   });
//
//   // Get dates for the next week
//   Map<String, String> nextWeekDates = getNextWeek(inputDate);
//   print("\nNext Week:");
//   nextWeekDates.forEach((day, date) {
//     print('$day: $date');
//   });
//
//   List<String> dates = [
//     "2024-06-21",
//     "2024-06-22",
//     "2024-06-23",
//     "2024-06-24",
//     "2024-06-25",
//     "2024-06-26",
//     "2024-06-27"
//   ];
//
//   var result = await getWeeksCalories(
//       dates[0], dates[1], dates[2], dates[3], dates[4], dates[5], dates[6]);
//
//   print(result);
// }
