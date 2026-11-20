import 'package:flutter/material.dart';

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête : Photo, Nom et Titre/Profil
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: primaryColor.withOpacity(0.15),
                    backgroundImage: const AssetImage(
                      'assets/images/profil.jpg',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ANGALIKIANA BAHATI RUBEN',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Étudiant en Informatique appliquée à la gestion des entreprises  - Passionné par le développement logiciel',
                    style: TextStyle(
                      fontSize: 15,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Passionné par le développement logiciel et la création d’applications mobiles modernes, performantes et intuitives.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section Formation
          _buildSection(
            context,
            titre: 'Formation',
            icone: Icons.school,
            enfants: const [
              _ItemParcours(
                titre: 'Licence en Informatique appliquée à la gestion des entreprises / Informatique',
                sousTitre: 'Université / ISIG GOMA • 2027 - Présent',
                description: 'Programmation orientée objet, bases de données, développement mobile et web.',
              ),
              Divider(),
              _ItemParcours(
                titre: 'Diplôme d’État / Baccalauréat',
                sousTitre: 'ITIG • 2022',
                description: 'Mécanique Automobile   - Technique / Mécanique.',
              ),
            ],
          ),

          // Section Expériences
          _buildSection(
            context,
            titre: 'Expériences & Projets',
            icone: Icons.work,
            enfants: const [
              _ItemParcours(
                titre: 'Développeur Flutter (Projet Académique)',
                sousTitre: 'Application Mobile CV & Portfolio • 2026',
                description: 'Conception d’une application multi-écrans avec authentification et navigation dynamique.',
              ),
              Divider(),
              _ItemParcours(
                titre: 'Stagiaire en éléctricité et électronique',
                sousTitre: 'GOSHOP •  Juillet 2025',
                description: 'Pratiques sur les installations électriques et électroniques, maintenance et dépannage.',
              ),
            ],
          ),

          // Section Compétences Techniques
          _buildSection(
            context,
            titre: 'Compétences Techniques',
            icone: Icons.code,
            enfants: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  Chip(label: Text('Flutter & Dart')),
                  Chip(label: Text('Git & GitHub')),
                  Chip(label: Text('HTML / CSS')),
                  Chip(label: Text('Python / Java')),
                  Chip(label: Text('SQL / Firebase')),
                  Chip(label: Text('UI/UX Design')),
                ],
              ),
            ],
          ),

          // Section Compétences Linguistiques
          _buildSection(
            context,
            titre: 'Compétences Linguistiques',
            icone: Icons.language,
            enfants: const [
              _ItemLangue(langue: 'Français', niveau: 'Courant (C1/C2)'),
              SizedBox(height: 8),
              _ItemLangue(
                langue: 'Anglais',
                niveau: 'Intermédiaire / Technique (B1/B2)',
              ),
              SizedBox(height: 8),
              _ItemLangue(
                langue: 'Swahili / Lingala',
                niveau: 'Langue maternelle / Courant',
              ),
            ],
          ),

          // Section Centres d'intérêt
          _buildSection(
            context,
            titre: 'Centres d’intérêt',
            icone: Icons.favorite,
            enfants: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  Chip(
                    avatar: Icon(Icons.sports_soccer, size: 18),
                    label: Text('Football'),
                  ),
                  Chip(
                    avatar: Icon(Icons.menu_book, size: 18),
                    label: Text('Lecture Tech'),
                  ),
                  Chip(
                    avatar: Icon(Icons.music_note, size: 18),
                    label: Text('Musique'),
                  ),
                  Chip(
                    avatar: Icon(Icons.travel_explore, size: 18),
                    label: Text('Nouvelles Technologies'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String titre,
    required IconData icone,
    required List<Widget> enfants,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icone, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  titre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...enfants,
          ],
        ),
      ),
    );
  }
}

class _ItemParcours extends StatelessWidget {
  final String titre;
  final String sousTitre;
  final String description;

  const _ItemParcours({
    required this.titre,
    required this.sousTitre,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titre,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 2),
          Text(
            sousTitre,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _ItemLangue extends StatelessWidget {
  final String langue;
  final String niveau;

  const _ItemLangue({required this.langue, required this.niveau});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(langue, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(niveau, style: TextStyle(color: Colors.grey.shade700)),
      ],
    );
  }
}
