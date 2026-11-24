import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../config/api_config.dart';
import '../models/membre_famille.dart';

class FamilleService {
  String get _baseEndpoint => '${ApiConfig.baseUrl}/famille-membres';

  Future<List<MembreFamille>> getMembres() async {
    final response = await http.get(
      Uri.parse(_baseEndpoint),
      headers: {'Accept': 'application/json'},
    );

    final body = _decodeSafe(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(
        body['message'] ?? 'Erreur lors du chargement des membres.',
      );
    }

    final data = body['data'];
    if (data is List) {
      return data
          .map(
            (item) =>
                MembreFamille.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    }
    return [];
  }

  Future<MembreFamille> createMembre(
    MembreFamille membre, {
    XFile? imageFile,
  }) async {
    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      final request = http.MultipartRequest('POST', Uri.parse(_baseEndpoint));
      request.headers['Accept'] = 'application/json';
      request.fields.addAll(membre.toFields());
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: imageFile.name.isNotEmpty ? imageFile.name : 'photo.jpg',
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final body = _decodeSafe(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          body['success'] == true) {
        return MembreFamille.fromJson(body['data'] as Map<String, dynamic>);
      }
      throw Exception(_extractError(body, 'Impossible de créer le membre.'));
    } else {
      final response = await http.post(
        Uri.parse(_baseEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(membre.toJson()),
      );

      final body = _decodeSafe(response.body);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          body['success'] == true) {
        return MembreFamille.fromJson(body['data'] as Map<String, dynamic>);
      }
      throw Exception(_extractError(body, 'Impossible de créer le membre.'));
    }
  }

  Future<MembreFamille> updateMembre(
    MembreFamille membre, {
    XFile? nouvelleImage,
  }) async {
    if (membre.id == null) {
      throw Exception('ID du membre manquant pour la modification.');
    }

    final url = '$_baseEndpoint/${membre.id}';

    if (nouvelleImage != null) {
      // L'API exige POST en form-data pour changer l'image d'un membre existant
      final bytes = await nouvelleImage.readAsBytes();
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Accept'] = 'application/json';
      request.fields.addAll(membre.toFields());
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: nouvelleImage.name.isNotEmpty
              ? nouvelleImage.name
              : 'photo.jpg',
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final body = _decodeSafe(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        return MembreFamille.fromJson(body['data'] as Map<String, dynamic>);
      }
      throw Exception(_extractError(body, 'Impossible de modifier le membre.'));
    } else {
      // PUT en JSON conserve l'image actuelle
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(membre.toJson()),
      );

      final body = _decodeSafe(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        return MembreFamille.fromJson(body['data'] as Map<String, dynamic>);
      }
      throw Exception(_extractError(body, 'Impossible de modifier le membre.'));
    }
  }

  Future<void> deleteMembre(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseEndpoint/$id'),
      headers: {'Accept': 'application/json'},
    );

    final body = _decodeSafe(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Impossible de supprimer le membre.');
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

  String _extractError(Map<String, dynamic> body, String fallback) {
    String msg = (body['message'] ?? fallback).toString();
    if (body['errors'] is Map) {
      final details = (body['errors'] as Map).values.join(' • ');
      if (details.isNotEmpty) msg = '$msg : $details';
    }
    return msg;
  }
}
