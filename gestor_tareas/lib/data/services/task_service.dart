import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  final String baseUrl = "http://localhost:3000";

  Future<List<dynamic>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener tareas');
    }
  }

  Future<bool> createTask(Map<String, dynamic> task) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(task),
    );

    return response.statusCode == 200;
  }

  Future<bool> completeTask(int taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$taskId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'completed': true}),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteTask(int taskId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final response = await http.delete(
    Uri.parse('$baseUrl/tasks/$taskId'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  return response.statusCode == 200;
}

}
