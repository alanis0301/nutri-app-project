import 'package:flutter/material.dart';

import '../widgets/profile/profile_header.dart';
import 'preferences_page.dart';
import 'tracking_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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

            _buildUserHeader(),
            const SizedBox(height: 24),

            _buildHighlightCard(
              icon: Icons.tune,
              title: 'Editar preferências',
              subtitle: 'Gostos, restrições e objetivos',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PreferencesPage()),
                  );
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
                  _buildAccountItem(Icons.person_outline, 'Dados pessoais'),
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
              onTap: () {},
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

  Widget _buildUserHeader() {
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
          child: const Text(
            'A',
            style: TextStyle(
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
                'Ana',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'ana.silva@email.com',
                style: TextStyle(fontSize: 13, color: grayText),
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

  Widget _buildAccountItem(IconData icon, String label) {
    return InkWell(
      onTap: () {},
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

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Divider(height: 1, color: borderColor),
    );
  }
}