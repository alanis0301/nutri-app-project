import 'package:flutter/material.dart';
import 'package:nutri_app_project/models/recipe_filters.dart';
import 'package:nutri_app_project/widgets/recipes/filters/recipe_bottom_bar.dart';
import 'package:nutri_app_project/widgets/recipes/filters/ingredient_search.dart';
import 'package:nutri_app_project/widgets/recipes/filters/ingredient.dart';
import 'package:nutri_app_project/widgets/recipes/filters/filter_options.dart';
import 'package:nutri_app_project/widgets/recipes/filters/filter_section_title.dart';

class RecipeFiltersPage extends StatefulWidget {
  const RecipeFiltersPage({super.key});

  @override
  State<RecipeFiltersPage> createState() => _RecipeFiltersPageState();
}

class _RecipeFiltersPageState extends State<RecipeFiltersPage> {
  static const Color verde = Color(0xFF20C663);
  static const Color texto = Color(0xFF172033);
  static const Color borda = Color(0xFFE1E5EAB);

  final TextEditingController _ingredientController = TextEditingController();

  final List<String> _preparationTimes = [
    'Até 15 min',
    '15 a 30 min',
    '30 a 45 min',
    'Mais de 45 min',
  ];

  final List<String> _mealTypes = [
    'Café da manhã',
    'Almoço',
    'Jantar',
    'Lanche',
    'Sobremesa',
  ];

  final List<String> _availableIngredients = [
    'Frango',
    'Ovo',
    'Tomate',
    'Brócolis',
    'Arroz',
    'Batata',
    'Cenoura',
    'Queijo',
    'Feijão',
  ];

  final Set<String> _selectedTimes = {'15 a 30 min'};

  final Set<String> _selectedMeals = {
    'Almoço',
    'Jantar',
  };

  final Set<String> _selectedIngredients = {
    'Frango',
    'Ovo',
    'Tomate',
    'Brócolis',
  };

  List<String> get _filteredIngredients {
    final query = _ingredientController.text.trim().toLowerCase();

    return _availableIngredients.where((ingredient) {
      return ingredient.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  void _toggleSelection(
    Set<String> selection,
    String value,
  ) {
    setState(() {
      if (selection.contains(value)) {
        selection.remove(value);
      } else {
        selection.add(value);
      }
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedTimes.clear();
      _selectedMeals.clear();
      _selectedIngredients.clear();
      _ingredientController.clear();
    });
  }

  void _applyFilters() {
    final filters = RecipeFilters(
      tempos: Set<String>.from(_selectedTimes),
      refeicoes: Set<String>.from(_selectedMeals),
      ingredientes: Set<String>.from(_selectedIngredients),
    );

    Navigator.pop(context, filters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.cancel_outlined,
            color: texto,
            size: 20,
          ),
        ),
        title: const Text(
          'Filtrar receitas',
          style: TextStyle(
            color: texto,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _clearFilters,
            child: const Text(
              'Limpar',
              style: TextStyle(
                color: Color(0xFF168B43),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: borda),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          24,
          25,
          24,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilterTitle(title: 'Tempo de preparo'),
            const SizedBox(height: 12),
            FilterOptions(
              options: _preparationTimes,
              selection: _selectedTimes,
              onOptionTap: (option) {
                _toggleSelection(_selectedTimes, option);
              },
            ),
            const SizedBox(height: 30),
            FilterTitle(title: 'Tipo de refeição'),
            const SizedBox(height: 12),
            FilterOptions(
              options: _mealTypes,
              selection: _selectedMeals,
              onOptionTap: (option) {
                _toggleSelection(_selectedMeals, option);
              },
            ),
            const SizedBox(height: 30),
            FilterTitle(title: 'Ingredientes disponíveis'),
            const SizedBox(height: 12),
            IngredientSearch(
              controller: _ingredientController,
              onChanged: (_) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            Ingredient(
              ingredients: _filteredIngredients,
              selectedIngredients: _selectedIngredients,
              onIngredientTap: (ingredient) {
                _toggleSelection(
                  _selectedIngredients,
                  ingredient,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: RecipesBottomBar(
        onApplyFilters: _applyFilters,
        verde: verde,
      ),
    );
  }
}
