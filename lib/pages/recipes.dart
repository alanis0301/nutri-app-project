import 'package:flutter/material.dart';

import '../widgets/recipes/recipes_header.dart';
import '../widgets/recipes/search_recipes.dart';
import '../widgets/recipes/filter_recipes.dart';
import '../widgets/recipes/recipe_card.dart';
import '../widgets/recipes/category_widget.dart';
import 'recipe_details.dart';
import '../services/api.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  static const greenColor = Color(0xFF16C768);

  // Receitas vindas do backend; a busca usa o Elasticsearch.
  late Future<List<Map<String, dynamic>>> _recipes = Api.recipes();

  void _search(String text) {
    setState(() {
      _recipes = text.trim().isEmpty ? Api.recipes() : Api.searchRecipes(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Título + Botão Filtro Lateral
              const RecipesHeader(),
              const SizedBox(height: 24),
              // Campo de Busca
              SearchRecipes(onSubmitted: _search),
              const SizedBox(height: 16),
              // Chips de Filtro
              const FilterRecipes(),
              const SizedBox(height: 24),

              // Seção: Receitas rápidas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Receitas rápidas para você',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1C1E),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Ver todas',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: greenColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Lista Horizontal de Receitas
              SizedBox(
                height: 210,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _recipes,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Erro ao carregar receitas: ${snapshot.error}'),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: greenColor),
                      );
                    }
                    final recipes = snapshot.data!;
                    if (recipes.isEmpty) {
                      return const Center(child: Text('Nenhuma receita encontrada'));
                    }
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: recipes.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, i) {
                        final recipe = recipes[i];
                        return RecipeCard(
                          title: recipe['name'],
                          time: '${(recipe['prepTime'] as num).round()} min',
                          difficulty: recipe['difficulty'] ?? '',
                          imageUrl: recipe['imageUrl'] ?? '',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailPage(recipe: recipe),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Seção: Categorias
              const Text(
                'Categorias',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1C1E),
                ),
              ),
              const SizedBox(height: 16),

              // Grid de Categorias
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.6,
                children: const [
                  const CategoryWidget(
                    label: 'Café da manhã',
                    iconWidget:
                        Icon(Icons.wb_sunny_outlined, color: Colors.amber),
                  ),
                  const CategoryWidget(
                    label: 'Almoço',
                    iconWidget: Text('🍽️', style: TextStyle(fontSize: 18)),
                  ),
                  const CategoryWidget(
                    label: 'Jantar',
                    iconWidget: Text('🌙', style: TextStyle(fontSize: 18)),
                  ),
                  const CategoryWidget(
                    label: 'Lanches',
                    iconWidget: Text('🥪', style: TextStyle(fontSize: 18)),
                  ),
                  const CategoryWidget(
                    label: 'Sobremesas',
                    iconWidget: Text('🍰', style: TextStyle(fontSize: 18)),
                  ),
                  const CategoryWidget(
                    label: 'Saladas',
                    iconWidget: Text('🥗', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
