import 'package:flutter/material.dart';

import '../widgets/recipes/recipes_header.dart';
import '../widgets/recipes/search_recipes.dart';
import '../widgets/recipes/filter_recipes.dart';
import '../widgets/recipes/recipe_card.dart';
import '../widgets/recipes/category_widget.dart';
import 'recipe_details.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});
  static const greenColor = Color(0xFF16C768);

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
              const SearchRecipes(),
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
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    RecipeCard(
                      title: 'Omelete de forno',
                      time: '15 min',
                      difficulty: 'Fácil',
                      imageUrl:
                          'https://images.unsplash.com/photo-1510693206972-df098062cb71?auto=format&fit=crop&w=500&q=80',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecipeDetailPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    RecipeCard(
                      title: 'Wrap de frango',
                      time: '20 min',
                      difficulty: 'Fácil',
                      imageUrl:
                          'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&w=500&q=80',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecipeDetailPage(),
                          ),
                        );
                      },
                    ),
                  ],
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
