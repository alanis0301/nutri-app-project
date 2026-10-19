import 'package:flutter/material.dart';
import 'circle_button.dart';

class RecipeImage extends StatefulWidget {
  final String? imageUrl;

  const RecipeImage({super.key, this.imageUrl});

  @override
  State<RecipeImage> createState() => _RecipeImageState();
}

class _RecipeImageState extends State<RecipeImage> {
  // 1. Declaração da variável de estado aqui
  bool isFavorite = false;

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
          Image(
            image: widget.imageUrl != null
                ? NetworkImage(widget.imageUrl!)
                : const AssetImage('assets/images/salmao_batata_brocolis.jpg')
                    as ImageProvider,
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
              onTap: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}