class MembreFamille {
  final int? id;
  final String nom;
  final String postnom;
  final String prenom;
  final String lieuNaissance;
  final String dateNaissance; // Format AAAA-MM-JJ
  final String parente;
  final String? imageUrl;

  const MembreFamille({
    this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  String get nomComplet {
    final parties = [prenom, postnom, nom].where((e) => e.trim().isNotEmpty).toList();
    return parties.join(' ');
  }

  factory MembreFamille.fromJson(Map<String, dynamic> json) {
    return MembreFamille(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      nom: (json['nom'] ?? '').toString(),
      postnom: (json['postnom'] ?? '').toString(),
      prenom: (json['prenom'] ?? '').toString(),
      lieuNaissance: (json['lieu_naissance'] ?? '').toString(),
      dateNaissance: (json['date_naissance'] ?? '').toString(),
      parente: (json['parente'] ?? '').toString(),
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom.trim(),
      'postnom': postnom.trim(),
      'prenom': prenom.trim(),
      'lieu_naissance': lieuNaissance.trim(),
      'date_naissance': dateNaissance.trim(),
      'parente': parente.trim(),
    };
  }

  Map<String, String> toFields() {
    return {
      'nom': nom.trim(),
      'postnom': postnom.trim(),
      'prenom': prenom.trim(),
      'lieu_naissance': lieuNaissance.trim(),
      'date_naissance': dateNaissance.trim(),
      'parente': parente.trim(),
    };
  }
}