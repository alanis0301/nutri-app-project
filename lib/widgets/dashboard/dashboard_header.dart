import 'package:flutter/material.dart';
import '../../pages/preferences_page.dart';

class DashboardHeader extends StatelessWidget {
  final String name;
  final VoidCallback onPreferencesSaved;

  const DashboardHeader({
    super.key,
    required this.name,
    required this.onPreferencesSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Título + Botão Filtro Lateral
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Olá, $name!',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1C1E),
                  ),
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F5F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.tune,
                    color: Color(0xFF1A1C1E),
                    size: 20,
                  ),
                  onPressed: () async {
                    final saved = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PreferencesPage()),
                    );
                    if (saved != null) onPreferencesSaved();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ))
    ]);
  }
}
