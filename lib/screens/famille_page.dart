import 'package:flutter/material.dart';

import '../models/membre_famille.dart';

class FamillePage extends StatelessWidget {
  const FamillePage({super.key});

  final List<MembreFamille> membres = const [
    MembreFamille(
      nom: 'CELESTIN',
      lienParente: 'Père',
      profession: 'Ingénieur Civil',
      photoAsset: 'assets/images/pere.jpg',
    ),
    MembreFamille(
      nom: 'Marie',
      lienParente: 'Mère',
      profession: 'Enseignante',
      photoAsset: 'assets/images/mere.jpg',
    ),
    MembreFamille(
      nom: 'Sarah',
      lienParente: 'Sœur',
      profession: 'Étudiante en Médecine',
      photoAsset: 'assets/images/soeur.jpg',
    ),
    MembreFamille(
      nom: 'David',
      lienParente: 'Frère',
      profession: 'manager dans une entreprise de technologie',
      photoAsset: 'assets/images/frere.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: membres.length,
      itemBuilder: (context, index) {
        final membre = membres[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: primaryColor.withOpacity(0.15),
                  backgroundImage: AssetImage(membre.photoAsset),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        membre.nom,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          membre.lienParente,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              membre.profession,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
