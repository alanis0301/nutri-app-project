import 'package:flutter/material.dart';

import '../services/api.dart';
import 'recipe_details.dart';

/// "Ver todas": todas as receitas em lista vertical.
class AllRecipesPage extends StatefulWidget {
  const AllRecipesPage({super.key});

  @override
  State<AllRecipesPage> createState() => _AllRecipesPageState();
}

class _AllRecipesPageState extends State<AllRecipesPage> {
  static const Color green = Color(0xFF16C768);
  static const Color darkGreen = Color(0xFF07863D);
  static const Color darkText = Color(0xFF1A1C1E);
  static const Color grayText = Color(0xFF697386);
  static const Color borderColor = Color(0xFFE1E5EB);

  late Future<List<Map<String, dynamic>>> recipes = Api.recipes();

  Future<void> _toggleFavorite(Map<String, dynamic> recipe) async {
    final favorite = await Api.toggleFavorite(recipe['id']);
    setState(() => recipe['favorite'] = favorite);
  }

  Future<void> _open(Map<String, dynamic> recipe) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe)),
    );
    setState(() {}); // o favorito pode ter mudado no detalhe
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: darkText),
        title: const Text(
          'Todas as receitas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: darkText,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: borderColor),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: recipes,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextButton(
                onPressed: () => setState(() => recipes = Api.recipes()),
                child: Text('Erro: ${snapshot.error}\nTentar de novo',
                    textAlign: TextAlign.center),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: green));
          }
          final list = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _buildRow(list[i]),
          );
        },
      ),
    );
  }

  Widget _buildRow(Map<String, dynamic> recipe) {
    final favorite = recipe['favorite'] == true;
    return InkWell(
      onTap: () => _open(recipe),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                recipe['imageUrl'] ?? '',
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 76,
                  height: 76,
                  color: const Color(0xFFE8F8EE),
                  child: const Icon(Icons.restaurant, color: darkGreen),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${(recipe['prepTime'] as num).round()} min · '
                    '${recipe['difficulty'] ?? '-'} · '
                    '${recipe['calories'] ?? '-'} kcal',
                    style: const TextStyle(fontSize: 12, color: grayText),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FBF4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      recipe['mealType'] ?? '',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: darkGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: favorite ? 'Remover dos favoritos' : 'Favoritar',
              onPressed: () => _toggleFavorite(recipe),
              icon: Icon(
                favorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
