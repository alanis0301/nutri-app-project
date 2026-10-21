import 'package:flutter/material.dart';

import '../services/api.dart';
import 'main_page.dart';
import 'preferences_page.dart';

/// Entrada do app: login ou criação de conta (RF01).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color green = Color(0xFF16C768);
  static const Color darkText = Color(0xFF1A1C1E);
  static const Color grayText = Color(0xFF697386);
  static const Color borderColor = Color(0xFFE1E5EB);

  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool creatingAccount = false;
  bool loading = false;
  String? error;

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = nameController.text.trim();
    final password = passwordController.text;
    if (name.isEmpty || password.isEmpty) {
      setState(() => error = 'Preencha nome e senha.');
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      if (creatingAccount) {
        await Api.signUp(name, password);
      } else if (await Api.login(name, password) == null) {
        setState(() {
          loading = false;
          error = 'Usuário ou senha incorretos.';
        });
        return;
      }
    } catch (e) {
      setState(() {
        loading = false;
        error = '$e';
      });
      return;
    }
    if (!mounted) return;
    // Conta nova: pede objetivo, restrições e preferências (RF02/RF03) antes do início,
    // para o dashboard já carregar com as sugestões certas.
    if (creatingAccount) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const PreferencesPage()),
      );
      if (!mounted) return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainPage()),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: grayText),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: green, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.eco_rounded, color: green, size: 56),
                  const SizedBox(height: 12),
                  const Text(
                    'NutriViver',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    creatingAccount
                        ? 'Crie sua conta para montar seu cardápio.'
                        : 'Entre para ver seu cardápio.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: grayText),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    decoration: _decoration('Nome de usuário', Icons.person_outline),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    onSubmitted: (_) => _submit(),
                    decoration: _decoration('Senha', Icons.lock_outline),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(error!, style: const TextStyle(color: Colors.redAccent)),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              creatingAccount ? 'Criar conta' : 'Entrar',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: loading
                        ? null
                        : () => setState(() {
                              creatingAccount = !creatingAccount;
                              error = null;
                            }),
                    child: Text(
                      creatingAccount
                          ? 'Já tenho conta'
                          : 'Não tem conta? Criar conta',
                      style: const TextStyle(color: Color(0xFF07863D)),
                    ),
                  ),
                  if (loading)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'O servidor pode levar até 1 minuto para acordar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: grayText),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
