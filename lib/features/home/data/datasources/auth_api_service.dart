import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApiService {
  final String baseUrl;
  AuthApiService(this.baseUrl);

  Future<Map<String, dynamic>> registerOwner(Map<String, dynamic> ownerData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuario'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ownerData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al registrar dueño');
    }
  }

  Future<Map<String, dynamic>> registerLocal(Map<String, dynamic> localData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/local'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(localData),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al registrar local');
    }
  }
}