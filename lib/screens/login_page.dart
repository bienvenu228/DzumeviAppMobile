import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Le résultat est un objet Admin (voir AuthService et Admin.dart)
      final adminResult = await _authService.loginAdmin(
        _nameController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        // Si la fonction loginAdmin s'exécute sans erreur, la connexion est réussie.

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connexion réussie'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Nouvelle logique (correcte) : Redirection vers la page admin
        // Si l'objet Admin n'est pas nul, c'est que c'est un admin.
        if (adminResult != null) { 
            // NOTE: Vous devriez passer les informations de l'admin à votre gestionnaire d'état ici
            Navigator.pushReplacementNamed(context, '/admin');
        } else {
            // Cette branche ne devrait pas être atteinte si loginAdmin réussit
            Navigator.pushReplacementNamed(context, '/'); 
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  // Couleurs personnalisées pour simuler l'arrière-plan
  final Color _primaryColor = const Color(0xFF673AB7); // Un violet foncé
  final Color _secondaryColor = const Color(0xFFE0E0F8); // Un fond très clair
  final Color _textFieldFillColor = const Color(0xFFF2F3F8); // Couleur de remplissage des champs
  final Color _cardColor = Colors.white; // La couleur de la carte centrale

  @override
  Widget build(BuildContext context) {
    // Utiliser un décor de boîte pour simuler le dégradé en arrière-plan
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              _primaryColor.withOpacity(0.4),
              _primaryColor.withOpacity(0.1),
              _primaryColor.withOpacity(0.0),
              _primaryColor.withOpacity(0.4),
            ],
            stops: const [0.0, 0.4, 0.6, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: 400, // Limiter la largeur sur les grands écrans
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- En-tête ---
                  const Text(
                    'DZUMEVI Admin Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Veuillez vous connecter pour continuer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- Afficher les erreurs ---
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          border: Border.all(color: Colors.red[400]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red[700]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // --- Formulaire ---
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Champ Nom d'utilisateur
                        const Text('Nom d\'utilisateur', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.text, // Changé de email à text pour un nom d'utilisateur
                          decoration: _inputDecoration(
                            hintText: 'Entrez votre nom d\'utilisateur',
                            suffixIcon: const Icon(Icons.person, color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ce champ est obligatoire';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Champ Mot de passe
                        const Text('Mot de passe', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          enabled: !_isLoading,
                          obscureText: _obscurePassword,
                          decoration: _inputDecoration(
                            hintText: 'Entrez votre mot de passe',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le mot de passe est obligatoire';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Bouton de connexion
                        SizedBox(
                          height: 50,
                          width: 500,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              disabledBackgroundColor: _primaryColor.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  // --- Informations de démo ---
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Fonction utilitaire pour le style des champs de texte
  InputDecoration _inputDecoration({required String hintText, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: _textFieldFillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none, // Supprimer la bordure par défaut
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: _primaryColor, width: 2), // Bordure colorée au focus
      ),
    );
  }
}