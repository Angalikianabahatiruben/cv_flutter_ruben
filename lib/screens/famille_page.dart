import 'package:flutter/material.dart';
import '../models/membre_famille.dart';
import '../services/famille_service.dart';
import '../widgets/membre_form_dialog.dart';

class FamillePage extends StatefulWidget {
  const FamillePage({super.key});

  @override
  State<FamillePage> createState() => _FamillePageState();
}

class _FamillePageState extends State<FamillePage> {
  final FamilleService _service = FamilleService();
  List<MembreFamille> _membres = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _chargerMembres();
  }

  Future<void> _chargerMembres() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final liste = await _service.getMembres();
      if (!mounted) return;
      setState(() {
        _membres = liste;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _ouvrirFormulaire({MembreFamille? membre}) async {
    final MembreFormResult? result = await showDialog<MembreFormResult>(
      context: context,
      builder: (_) => MembreFormDialog(membreInitial: membre),
    );

    if (result == null) return;

    try {
      if (membre == null) {
        await _service.createMembre(result.membre, imageFile: result.imageFile);
        _notifier('Membre ajouté avec succès');
      } else {
        await _service.updateMembre(result.membre, nouvelleImage: result.imageFile);
        _notifier('Membre modifié avec succès');
      }
      await _chargerMembres();
    } catch (e) {
      _notifier(e.toString().replaceFirst('Exception: ', ''), isError: true);
    }
  }

  Future<void> _confirmerSuppression(MembreFamille membre) async {
    if (membre.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer ${membre.nomComplet} ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _service.deleteMembre(membre.id!);
      _notifier('Membre supprimé');
      await _chargerMembres();
    } catch (e) {
      _notifier(e.toString().replaceFirst('Exception: ', ''), isError: true);
    }
  }

  void _notifier(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _ouvrirFormulaire(),
        icon: const Icon(Icons.person_add),
        label: const Text('Ajouter'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wifi_off, size: 48, color: Colors.redAccent),
                        const SizedBox(height: 12),
                        Text(_errorMessage!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _chargerMembres,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                )
              : _membres.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.family_restroom, size: 54, color: Colors.grey.shade400),
                          const SizedBox(height: 10),
                          const Text('Aucun membre enregistré en base de données.'),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () => _ouvrirFormulaire(),
                            icon: const Icon(Icons.add),
                            label: const Text('Ajouter un membre'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _chargerMembres,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 84),
                        itemCount: _membres.length,
                        itemBuilder: (context, index) {
                          final m = _membres[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 14),
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 34,
                                    backgroundColor: primaryColor.withValues(alpha: 0.12),
                                    backgroundImage: (m.imageUrl != null && m.imageUrl!.isNotEmpty)
                                        ? NetworkImage(m.imageUrl!)
                                        : null,
                                    child: (m.imageUrl == null || m.imageUrl!.isEmpty)
                                        ? Icon(Icons.person, size: 32, color: primaryColor)
                                        : null,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          m.nomComplet,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: primaryColor.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            m.parente,
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.5,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Né(e) à ${m.lieuNaissance} • ${m.dateNaissance}',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        tooltip: 'Modifier',
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _ouvrirFormulaire(membre: m),
                                      ),
                                      IconButton(
                                        tooltip: 'Supprimer',
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _confirmerSuppression(m),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}