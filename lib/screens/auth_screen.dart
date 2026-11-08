import 'package:flutter/material.dart';

import '../services/app_storage.dart';
import '../theme/app_theme.dart';
import 'calendar_screen.dart';

/// Tela única de Login/Cadastro.
/// Não implementei o sistema de segurança nem pouco outras proteções
/// que faço em PHP MySQL pois é somente para a questão ACQA.

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _raController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  // Coloquei para limpar estes dados
  void dispose() {
    _nameController.dispose();
    _raController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //Codigo copiado de outro modelo na internet pois não estou usando firebase
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final storage = AppStorage.instance;
    final error = _isLogin
        ? await storage.login(_emailController.text, _passwordController.text)
        : await storage.register(
            name: _nameController.text,
            ra: _raController.text,
            email: _emailController.text,
            password: _passwordController.text,
          );
    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const CalendarScreen()),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon,
    String? Function(String value) validator, {
    bool obscure = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        validator: (v) => validator(v?.trim() ?? ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.pink,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(Icons.checklist_rounded, size: 44),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Texto de Boas Vindas
                  const Text(
                    'ACQA Uniube',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    _isLogin ? 'Entre para ver suas tarefas' : 'Crie sua conta',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 28),
                  if (!_isLogin) ...[
                    _field(
                      _nameController,
                      'Nome',
                      Icons.person_rounded,
                      (v) => v.length < 3 ? 'Informe seu nome' : null,
                    ),
                    _field(
                      _raController,
                      'RA',
                      Icons.badge_rounded,
                      (v) => RegExp(r'^\d{4,}$').hasMatch(v)
                          ? null
                          : 'Use apenas números (mín. 4)',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                  _field(
                    _emailController,
                    'E-mail',
                    Icons.alternate_email_rounded,
                    (v) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)
                        ? null
                        : 'E-mail inválido',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _field(
                    _passwordController,
                    'Senha',
                    Icons.lock_rounded,
                    (v) => v.length < 6 ? 'Mínimo de 6 caracteres' : null,
                    obscure: true,
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _submit,
                    child: Text(_isLogin ? 'Entrar' : 'Cadastrar'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: Text(
                      _isLogin
                          ? 'Não tem conta? Cadastre-se'
                          : 'Já tem conta? Entrar',
                      style: const TextStyle(color: AppColors.lime),
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
