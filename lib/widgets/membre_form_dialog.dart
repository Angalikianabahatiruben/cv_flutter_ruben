import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/membre_famille.dart';

class MembreFormResult {
  final MembreFamille membre;
  final XFile? imageFile;

  const MembreFormResult({required this.membre, this.imageFile});
}

class MembreFormDialog extends StatefulWidget {
  final MembreFamille? membreInitial;

  const MembreFormDialog({super.key, this.membreInitial});

  @override
  State<MembreFormDialog> createState() => _MembreFormDialogState();
}

class _MembreFormDialogState extends State<MembreFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomController;
  late final TextEditingController _postnomController;
  late final TextEditingController _prenomController;
  late final TextEditingController _lieuController;
  late final TextEditingController _dateController;
  late final TextEditingController _parenteController;

  XFile? _imageSelectionnee;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final m = widget.membreInitial;
    _nomController = TextEditingController(text: m?.nom ?? '');
    _postnomController = TextEditingController(text: m?.postnom ?? '');
    _prenomController = TextEditingController(text: m?.prenom ?? '');
    _lieuController = TextEditingController(text: m?.lieuNaissance ?? '');
    _dateController = TextEditingController(text: m?.dateNaissance ?? '');
    _parenteController = TextEditingController(text: m?.parente ?? '');
  }

  Future<void> _choisirImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _imageSelectionnee = picked;
      });
    }
  }

  Future<void> _choisirDate() async {
    DateTime initial = DateTime(1995, 1, 1);
    final parsed = DateTime.tryParse(_dateController.text.trim());
    if (parsed != null) initial = parsed;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(DateTime.now())
          ? DateTime(2000, 1, 1)
          : initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final mm = picked.month.toString().padLeft(2, '0');
      final dd = picked.day.toString().padLeft(2, '0');
      _dateController.text = '${picked.year}-$mm-$dd';
    }
  }

  void _valider() {
    if (!_formKey.currentState!.validate()) return;

    final membre = MembreFamille(
      id: widget.membreInitial?.id,
      nom: _nomController.text.trim(),
      postnom: _postnomController.text.trim(),
      prenom: _prenomController.text.trim(),
      lieuNaissance: _lieuController.text.trim(),
      dateNaissance: _dateController.text.trim(),
      parente: _parenteController.text.trim(),
      imageUrl: widget.membreInitial?.imageUrl,
    );

    Navigator.pop(
      context,
      MembreFormResult(membre: membre, imageFile: _imageSelectionnee),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _postnomController.dispose();
    _prenomController.dispose();
    _lieuController.dispose();
    _dateController.dispose();
    _parenteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.membreInitial != null;

    ImageProvider? avatarImage;
    if (_imageSelectionnee != null) {
      avatarImage = NetworkImage(_imageSelectionnee!.path);
    } else if (widget.membreInitial?.imageUrl != null &&
        widget.membreInitial!.imageUrl!.isNotEmpty) {
      avatarImage = NetworkImage(widget.membreInitial!.imageUrl!);
    }

    return AlertDialog(
      title: Text(isEdit ? 'Modifier le membre' : 'Ajouter un membre'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _choisirImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: avatarImage,
                  child: avatarImage == null
                      ? const Icon(Icons.add_a_photo, size: 28)
                      : null,
                ),
              ),
              TextButton.icon(
                onPressed: _choisirImage,
                icon: const Icon(Icons.photo_library, size: 18),
                label: Text(
                  _imageSelectionnee != null
                      ? 'Changer la photo choisie'
                      : (isEdit
                            ? 'Modifier la photo (optionnel)'
                            : 'Choisir une photo (optionnel)'),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nom obligatoire' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _postnomController,
                decoration: const InputDecoration(
                  labelText: 'Postnom *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Postnom obligatoire'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(
                  labelText: 'Prénom *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Prénom obligatoire'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _parenteController,
                decoration: const InputDecoration(
                  labelText: 'Lien de parenté *',
                  hintText: 'Ex. : Père, Mère, Frère, Sœur',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Parenté obligatoire'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lieuController,
                decoration: const InputDecoration(
                  labelText: 'Lieu de naissance *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Lieu de naissance obligatoire'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _choisirDate,
                decoration: const InputDecoration(
                  labelText: 'Date de naissance (AAAA-MM-JJ) *',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Date de naissance obligatoire'
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _valider,
          child: Text(isEdit ? 'Enregistrer' : 'Ajouter'),
        ),
      ],
    );
  }
}
