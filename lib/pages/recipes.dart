import 'package:flutter/material.dart';

import '../models/recipe_filters.dart';
import '../services/api.dart';
import '../widgets/recipes/recipes_header.dart';
import '../widgets/recipes/search_recipes.dart';
import '../widgets/recipes/filter_recipes.dart';
import '../widgets/recipes/recipe_card.dart';
import '../widgets/recipes/category_widget.dart';
import 'filter_recipes_page.dart';
import 'recipe_details.dart';
import 'all_recipes_page.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  static const greenColor = Color(0xFF16C768);

  // Rótulo do grid -> tipo de refeição do backend (null = busca por texto).
  static const List<List<dynamic>> categories = [
    ['Café da manhã', 'Café da manhã', Icon(Icons.wb_sunny_outlined, color: Colors.amber)],
    ['Almoço', 'Almoço', Text('🍽️', style: TextStyle(fontSize: 18))],
    ['Jantar', 'Jantar', Text('🌙', style: TextStyle(fontSize: 18))],
    ['Lanches', 'Lanche', Text('🥪', style: TextStyle(fontSize: 18))],
    ['Sobremesas', 'Sobremesa', Text('🍰', style: TextStyle(fontSize: 18))],
    ['Saladas', null, Text('🥗', style: TextStyle(fontSize: 18))],
  ];

  final searchController = TextEditingController();
  RecipeFilters filters = RecipeFilters.empty;
  String title = 'Receitas rápidas para você';
  String? selectedCategory;
  late Future<List<Map<String, dynamic>>> _recipes = Api.recipes();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _show(String newTitle, Future<List<Map<String, dynamic>>> recipes,
      {String? category}) {
    setState(() {
      selectedCategory = category;
      title = newTitle;
      _recipes = recipes;
    });
  }

  void _showAll() {
    searchController.clear();
    filters = RecipeFilters.empty;
    _show('Receitas rápidas para você', Api.recipes());
  }

  /// "Ver todas": abre a lista vertical com todas as receitas.
  Future<void> _openAllRecipes() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AllRecipesPage()),
    );
    setState(() {}); // favoritos podem ter mudado
  }

  void _search(String text) {
    if (text.trim().isEmpty) {
      _showAll();
      return;
    }
    filters = RecipeFilters.empty;
    _show('Resultados para "${text.trim()}"', Api.searchRecipes(text));
  }

  void _openCategory(String label, String? mealType) {
    searchController.clear();
    // Tocar de novo na categoria selecionada desmarca.
    if (selectedCategory == label) {
      _showAll();
      return;
    }
    if (mealType == null) {
      filters = RecipeFilters.empty;
      _show(label, Api.searchRecipes(label.toLowerCase()), category: label);
    } else {
      filters = RecipeFilters(tempos: const {}, refeicoes: {mealType}, ingredientes: const {});
      _show(label, _query(filters), category: label);
    }
  }

  Future<List<Map<String, dynamic>>> _query(RecipeFilters f) => Api.recipes(
        mealTypes: f.refeicoes.isEmpty ? null : f.refeicoes.toList(),
        minPrepTime: f.minPrepTime,
        maxPrepTime: f.maxPrepTime,
        ingredients: f.ingredientes.isEmpty ? null : f.ingredientes.toList(),
      );

  Future<void> _openFilters() async {
    final result = await Navigator.push<RecipeFilters>(
      context,
      MaterialPageRoute(builder: (_) => RecipeFiltersPage(initial: filters)),
    );
    if (result == null || !mounted) return;
    searchController.clear();
    filters = result;
    _show(result.isEmpty ? 'Todas as receitas' : 'Receitas filtradas', _query(result));
  }

  Future<void> _toggleFavorite(Map<String, dynamic> recipe) async {
    final favorite = await Api.toggleFavorite(recipe['id']);
    setState(() => recipe['favorite'] = favorite);
  }

  Future<void> _openRecipe(Map<String, dynamic> recipe) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe)),
    );
    setState(() {}); // o favorito pode ter mudado na tela de detalhes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Título + Botão Filtro Lateral
              const RecipesHeader(),
              const SizedBox(height: 24),
              // Campo de Busca
              SearchRecipes(controller: searchController, onSubmitted: _search),
              const SizedBox(height: 16),
              // Chips de Filtro
              FilterRecipes(filters: filters, onOpenFilters: _openFilters),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1C1E),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _openAllRecipes,
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

              // Lista horizontal de receitas
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
                          favorite: recipe['favorite'] == true,
                          onFavorite: () => _toggleFavorite(recipe),
                          onTap: () => _openRecipe(recipe),
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
                children: categories.map((c) {
                  return InkWell(
                    onTap: () => _openCategory(c[0] as String, c[1] as String?),
                    borderRadius: BorderRadius.circular(14),
                    child: CategoryWidget(
                      label: c[0] as String,
                      iconWidget: c[2] as Widget,
                      selected: selectedCategory == c[0],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
