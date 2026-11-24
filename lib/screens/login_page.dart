import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'main_navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _motDePasseMasque = true;
  bool _isLoading = false;
  bool _modeInscription = false;

  Future<void> _soumettre() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final result = _modeInscription
        ? await _authService.register(email: email, password: password)
        : await _authService.login(email: email, password: password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      if (_modeInscription) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green.shade700,
            content: Text('${result.message}. Vous pouvez maintenant vous connecter.'),
          ),
        );
        setState(() => _modeInscription = false);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainNavigation(
              userEmail: result.userData?['email']?.toString() ?? email,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade700,
          content: Text(result.message),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor,
              primaryColor.withValues(alpha: 0.85),
              const Color(0xFF0F172A),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 10,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.lock_open_rounded, size: 46, color: primaryColor),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _modeInscription ? 'Créer un compte' : 'Connexion',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _modeInscription
                                ? 'Enregistrez votre compte via l’API REST'
                                : 'Authentification réelle via l’API REST',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Adresse e-mail',
                              hintText: 'exemple@domaine.com',
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            validator: (value) {
                              final v = (value ?? '').trim();
                              if (v.isEmpty) return 'Veuillez saisir votre e-mail';
                              if (!v.contains('@') || !v.contains('.')) {
                                return 'Adresse e-mail invalide';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _motDePasseMasque,
                            onFieldSubmitted: (_) => _isLoading ? null : _soumettre(),
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              hintText: 'Minimum 6 caractères',
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _motDePasseMasque
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () => setState(() => _motDePasseMasque = !_motDePasseMasque),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir votre mot de passe';
                              }
                              if (value.length < 6) {
                                return '6 caractères minimum requis';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _soumettre,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      _modeInscription ? 'S’inscrire' : 'Se connecter',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () => setState(() => _modeInscription = !_modeInscription),
                            child: Text(
                              _modeInscription
                                  ? 'Déjà un compte ? Se connecter'
                                  : 'Pas encore de compte ? Créer un compte',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}