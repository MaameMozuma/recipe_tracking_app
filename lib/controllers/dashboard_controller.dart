import 'dart:convert';
import 'package:team_proj_leanne/model/dashboard_stat.dart';
import 'package:team_proj_leanne/model/recipe_model.dart';
import 'package:team_proj_leanne/services/api_service.dart';

class DashboardController {
  final token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTcyMTQzMTgzNCwianRpIjoiOTlmMjU2NDYtYjBjNi00ZTk4LTg2M2MtYzkyNDcyZTcxZTBiIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6IkFkbWluMyIsIm5iZiI6MTcyMTQzMTgzNCwiZXhwIjoxNzI0MDIzODM0fQ.UbpT5ykTzGPMnuKVEPx8n_6D7Q192D1sXdfbmpQWLMg";
  final ApiService _apiService = ApiService();

  Future<DashboardStat> getStepSummary() async {
    final response = await _apiService.get('get_steps_summary', token: token);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      final DashboardStat stat = DashboardStat.fromJson(jsonData);
      return stat;
    } 
    else {
      throw Exception(
          'Failed to load stats. Status code: ${response.statusCode}');
    }
  }

  Future<DashboardStat> getCaloriesSummary() async {
    final response = await _apiService.get('get_calories_summary', token: token);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      final DashboardStat stat = DashboardStat.fromJson(jsonData);
      return stat;
    } 
    else {
      throw Exception(
          'Failed to load stats. Status code: ${response.statusCode}');
    }
  }
}
