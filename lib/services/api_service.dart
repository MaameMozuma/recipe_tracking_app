import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000';

  // Function to send a POST request with optional Authorization header
  Future<http.Response> post(String endpoint, dynamic data,
      {String? token}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null)
        'Authorization':
            'Bearer $token', // Conditionally add Authorization header
    };

    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    return response;
  }

  // Function to send a GET request with optional Authorization header
  Future<http.Response> get(String endpoint, {String? token}) async {
    final headers = <String, String>{
      if (token != null)
        'Authorization':
            'Bearer $token', // Conditionally add Authorization header
    };

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
    );
    return response;
  }

  // Function to send a DELETE request with optional Authorization header
  Future<http.Response> delete(String endpoint, {String? token}) async {
    final headers = <String, String>{
      if (token != null)
        'Authorization':
            'Bearer $token', // Conditionally add Authorization header
    };

    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
    );
    return response;
  }

  Future<http.Response> put(String endpoint, dynamic data,
      {String? token}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null)
        'Authorization':
            'Bearer $token', // Conditionally add Authorization header
    };

    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    return response;
  }

  Future<http.Response> patch(String endpoint, dynamic data,
      {String? token}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null)
        'Authorization':
            'Bearer $token', // Conditionally add Authorization header
    };

    final response = await http.patch(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    return response;
  }
}
