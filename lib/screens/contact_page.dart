import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _ouvrirLien(BuildContext context, String urlString) async {
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible d’ouvrir : $urlString')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12.0),
          child: Text(
            'Appuyez sur une carte pour interagir directement :',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ),
        _ContactCard(
          icone: Icons.phone,
          couleurIcone: Colors.green,
          titre: 'Téléphone',
          valeur: '+243 974 939 140',
          sousTitre: 'Appuyer pour lancer un appel',
          onTap: () => _ouvrirLien(context, 'tel:+243974939140'),
        ),
        _ContactCard(
          icone: Icons.email,
          couleurIcone: Colors.redAccent,
          titre: 'E-mail',
          valeur: 'bahatiruben23@gmail.com',
          sousTitre: 'Appuyer pour envoyer un e-mail',
          onTap: () => _ouvrirLien(
            context,
            'mailto:bahatiruben23@gmail.com?subject=Contact%20depuis%20ton%20CV',
          ),
        ),
        _ContactCard(
          icone: Icons.location_on,
          couleurIcone: Colors.orange,
          titre: 'Adresse',
          valeur: 'Goma, Nord-Kivu, RD Congo',
          sousTitre: 'Appuyer pour voir sur la carte',
          onTap: () => _ouvrirLien(context, 'https://maps.google.com/?q=Goma'),
        ),
        _ContactCard(
          icone: Icons.code,
          couleurIcone: Colors.black87,
          titre: 'GitHub',
          valeur: 'github.com/angalikianabahatiruben',
          sousTitre: 'Appuyer pour voir mes dépôts',
          onTap: () =>
              _ouvrirLien(context, 'https://github.com/angalikianabahatiruben'),
        ),
        _ContactCard(
          icone: Icons.business_center,
          couleurIcone: const Color(0xFF0A66C2),
          titre: 'LinkedIn',
          valeur: 'linkedin.com/in/ruben-bahatiruben-1a2b3c4d',
          sousTitre: 'Appuyer pour voir mon profil professionnel',
          onTap: () => _ouvrirLien(
            context,
            'https://www.linkedin.com/in/ruben-bahatiruben-1a2b3c4d',
          ),
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icone;
  final Color couleurIcone;
  final String titre;
  final String valeur;
  final String sousTitre;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icone,
    required this.couleurIcone,
    required this.titre,
    required this.valeur,
    required this.sousTitre,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: couleurIcone.withOpacity(0.12),
          child: Icon(icone, color: couleurIcone),
        ),
        title: Text(titre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              valeur,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
            ),
            const SizedBox(height: 2),
            Text(
              sousTitre,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
