import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  // URLs para desarrollo y producción
  // Para emulador Android usar 10.0.2.2 en lugar de localhost
  static const String developmentUrl = 'http://10.0.2.2:3000';
  static const String productionUrl = 'https://parkingnow-app-963963f523b4.herokuapp.com';
  
  // Obtener el ambiente desde variables de entorno
  static String get environment => const String.fromEnvironment(
    'ENVIRONMENT', 
    defaultValue: 'development' // Por defecto desarrollo
  );
  
  static bool get isProduction => environment == 'production';
  
  static String get baseUrl => isProduction ? productionUrl : developmentUrl;
  
  // Login con API real
  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      print('Intentando conectar a: $baseUrl/auth/login');
      print('Ambiente actual: $environment');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Login exitoso: ${responseData['user']}');
        // Login exitoso, devolvemos los datos completos incluyendo access_token
        return responseData;
      } else {
        print('Login fallido: ${responseData['message'] ?? 'Error desconocido'}');
        // Login fallido
        return null;
      }
    } catch (e) {
      // Error de conexión o parsing
      print('Error en login: $e');
      return null;
    }
  }

  // Registro con API real
  Future<Map<String, dynamic>?> register({
    required String name,
    required String email,
    required String password,
    required String ruc,
  }) async {
    try {
      print('Intentando registrar usuario en: $baseUrl/auth/register');
      print('Ambiente actual: $environment');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'ruc': ruc,
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Registro exitoso: ${responseData['user']}');
        // Registro exitoso, devolvemos los datos incluyendo el access_token
        return responseData;
      } else {
        print('Registro fallido: ${responseData['message'] ?? 'Error desconocido'}');
        // Registro fallido
        return null;
      }
    } catch (e) {
      // Error de conexión o parsing
      print('Error en registro: $e');
      return null;
    }
  }
}
