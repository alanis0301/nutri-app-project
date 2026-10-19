import 'package:flutter/material.dart';
import 'circle_button.dart';
import '../../../services/api.dart';

class RecipeImage extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const RecipeImage({super.key, required this.recipe});

  @override
  State<RecipeImage> createState() => _RecipeImageState();
}

class _RecipeImageState extends State<RecipeImage> {
  late bool isFavorite = widget.recipe['favorite'] == true;

  Future<void> _toggleFavorite() async {
    final favorite = await Api.toggleFavorite(widget.recipe['id']);
    widget.recipe['favorite'] = favorite;
    if (mounted) setState(() => isFavorite = favorite);
  }

  @override
  Widget build(BuildContext context) {
    // Definido o textColor padrão do Flutter ou da sua aplicação
    final textColor = Color(0xFF171E2E);

    return SizedBox(
      height: 232,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            widget.recipe['imageUrl'] ?? '',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFFE8ECE8),
                child: const Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 64,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),

          // Botão voltar
          Positioned(
            top: 16,
            left: 16,
            child: CircleButton(
              icon: Icons.chevron_left,
              onTap: () => Navigator.of(context).maybePop(),
              iconColor: textColor,
            ),
          ),

          // Botão de favorito
          Positioned(
            top: 16,
            right: 16,
            child: CircleButton(
              icon: isFavorite ? Icons.favorite : Icons.favorite_border,
              iconColor: isFavorite ? Colors.red : textColor,
              onTap: _toggleFavorite,
            ),
          ),
        ],
      ),
    );
  }
}