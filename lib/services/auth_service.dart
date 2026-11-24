import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class AuthResult {
  final bool success;
  final String message;
  final Map<String, dynamic>? userData;

  const AuthResult({
    required this.success,
    required this.message,
    this.userData,
  });
}

class AuthService {
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/accounts/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
      );

      final Map<String, dynamic> body = _decodeSafe(response.body);
      final bool ok = response.statusCode == 200 && (body['success'] == true);

      return AuthResult(
        success: ok,
        message: (body['message'] ?? (ok ? 'Connexion réussie' : 'Identifiants invalides')).toString(),
        userData: body['data'] is Map<String, dynamic> ? body['data'] : null,
      );
    } catch (e) {
      return const AuthResult(
        success: false,
        message: 'Impossible de contacter le serveur. Vérifiez XAMPP et l’URL de l’API.',
      );
    }
  }

  Future<AuthResult> register({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/accounts/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
      );

      final Map<String, dynamic> body = _decodeSafe(response.body);
      final bool ok = (response.statusCode == 200 || response.statusCode == 201) &&
          (body['success'] == true);

      String msg = (body['message'] ?? (ok ? 'Compte créé' : 'Erreur lors de la création')).toString();
      if (!ok && body['errors'] is Map) {
        final details = (body['errors'] as Map).values.join(' • ');
        if (details.isNotEmpty) msg = '$msg : $details';
      }

      return AuthResult(
        success: ok,
        message: msg,
        userData: body['data'] is Map<String, dynamic> ? body['data'] : null,
      );
    } catch (e) {
      return const AuthResult(
        success: false,
        message: 'Erreur réseau lors de la création du compte.',
      );
    }
  }

  Map<String, dynamic> _decodeSafe(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : {};
    } catch (_) {
      return {};
    }
  }
}