import 'package:flutter/material.dart';

import '../services/api.dart';
import '../widgets/profile/profile_header.dart';
import 'login_page.dart';
import 'preferences_page.dart';
import 'tracking_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> user = Api.me();

  static const Color green = Color(0xFF16C768);
  static const Color darkGreen = Color(0xFF07863D);
  static const Color darkText = Color(0xFF1A1C1E);
  static const Color grayText = Color(0xFF697386);
  static const Color borderColor = Color(0xFFE1E5EB);
  static const Color lightGreen = Color(0xFFF0FBF4);
  static const Color cardBg = Color(0xFFF8F9FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          18,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeader(),
            const SizedBox(height: 24),

            FutureBuilder<Map<String, dynamic>>(
              future: user,
              builder: (context, snapshot) => snapshot.hasData
                  ? _buildUserHeader(snapshot.data!)
                  : const SizedBox(height: 80),
            ),
            const SizedBox(height: 24),

            _buildHighlightCard(
              icon: Icons.tune,
              title: 'Editar preferências',
              subtitle: 'Gostos, restrições e objetivos',
                onTap: () async {
                  final saved = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PreferencesPage()),
                  );
                  if (saved != null) setState(() => user = Api.me());
                },
            ),
            const SizedBox(height: 12),
            _buildHighlightCard(
              icon: Icons.bar_chart_rounded,
              title: 'Meu acompanhamento',
              subtitle: 'Seu progresso e hábitos alimentares',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TrackingPage()),
                );
              },
            ),

            const SizedBox(height: 24),
            const Text(
              'Sua conta',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: grayText,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildAccountItem(
                    Icons.person_outline,
                    'Dados pessoais',
                    onTap: _showPersonalData,
                  ),
                  _divider(),
                  _buildAccountItem(
                    Icons.notifications_none,
                    'Notificações e lembretes',
                  ),
                  _divider(),
                  _buildAccountItem(
                    Icons.shield_outlined,
                    'Privacidade e segurança',
                  ),
                  _divider(),
                  _buildAccountItem(Icons.help_outline, 'Ajuda e suporte'),
                ],
              ),
            ),

            const SizedBox(height: 24),
            InkWell(
              onTap: _logout,
              borderRadius: BorderRadius.circular(13),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: grayText, size: 22),
                    SizedBox(width: 14),
                    Text(
                      'Sair da conta',
                      style: TextStyle(fontSize: 14, color: grayText),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            const Center(
              child: Text(
                'NutriViver · Versão 1.0.0',
                style: TextStyle(fontSize: 11, color: grayText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await Api.logout();
    } catch (_) {
      // Mesmo sem rede, o token local já foi descartado.
    }
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  Future<void> _showPersonalData() async {
    final data = await user;
    if (!mounted) return;
    String names(String key) {
      final list = (data[key] as List).map((e) => e['name']).join(', ');
      return list.isEmpty ? 'Nenhuma' : list;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dados pessoais'),
        content: Text(
          'Usuário: ${data['name']}\n'
          'Objetivo: ${data['goal']?['name'] ?? 'Não definido'}\n'
          'Restrições: ${names('restrictions')}\n'
          'Alimentos preferidos: ${names('preferences')}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final goal = data['goal']?['name'] as String?;
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: lightGreen,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            name.isEmpty ? '?' : name[0].toUpperCase(),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                goal == null ? 'Objetivo não definido' : 'Objetivo: $goal',
                style: const TextStyle(fontSize: 13, color: grayText),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: darkGreen, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: grayText),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: grayText, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountItem(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () => _comingSoon(label),
      borderRadius: BorderRadius.circular(17),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: darkText, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: darkText,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: grayText, size: 22),
          ],
        ),
      ),
    );
  }

  void _comingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label: fora do escopo da PoC.')),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Divider(height: 1, color: borderColor),
    );
  }
}