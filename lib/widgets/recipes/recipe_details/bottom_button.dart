import 'package:flutter/material.dart';
import '../../../pages/add_to_plan_page.dart';

/// "Adicionar ao plano" já com a receita aberta selecionada.
class BottomButton extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const BottomButton({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF19C45A);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      color: Colors.white,
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final added = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (context) => AddToPlanPage(recipe: recipe),
              ),
            );
            if (added == true) {
              messenger.showSnackBar(
                const SnackBar(content: Text('Receita adicionada ao plano.')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            elevation: 5,
            shadowColor: primaryGreen.withOpacity(0.25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Adicionar ao plano',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
