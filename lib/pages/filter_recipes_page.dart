import 'package:flutter/material.dart';
import 'package:nutri_app_project/models/recipe_filters.dart';
import 'package:nutri_app_project/services/api.dart';
import 'package:nutri_app_project/widgets/recipes/filters/recipe_bottom_bar.dart';
import 'package:nutri_app_project/widgets/recipes/filters/ingredient_search.dart';
import 'package:nutri_app_project/widgets/recipes/filters/ingredient.dart';
import 'package:nutri_app_project/widgets/recipes/filters/filter_options.dart';
import 'package:nutri_app_project/widgets/recipes/filters/filter_section_title.dart';

class RecipeFiltersPage extends StatefulWidget {
  final RecipeFilters initial;

  const RecipeFiltersPage({super.key, this.initial = RecipeFilters.empty});

  @override
  State<RecipeFiltersPage> createState() => _RecipeFiltersPageState();
}

class _RecipeFiltersPageState extends State<RecipeFiltersPage> {
  static const Color verde = Color(0xFF20C663);
  static const Color texto = Color(0xFF172033);
  static const Color borda = Color(0xFFE1E5EB);

  final TextEditingController _ingredientController = TextEditingController();

  final List<String> _preparationTimes = RecipeFilters.timeRanges.keys.toList();
  final List<String> _mealTypes = Api.mealTypes;
  List<String> _availableIngredients = [];

  late final Set<String> _selectedTimes = {...widget.initial.tempos};
  late final Set<String> _selectedMeals = {...widget.initial.refeicoes};
  late final Set<String> _selectedIngredients = {...widget.initial.ingredientes};

  int? _count;
  int _countRequest = 0;

  List<String> get _filteredIngredients {
    final query = _ingredientController.text.trim().toLowerCase();

    return _availableIngredients.where((ingredient) {
      return ingredient.toLowerCase().contains(query);
    }).toList();
  }

  RecipeFilters get _filters => RecipeFilters(
        tempos: Set<String>.from(_selectedTimes),
        refeicoes: Set<String>.from(_selectedMeals),
        ingredientes: Set<String>.from(_selectedIngredients),
      );

  @override
  void initState() {
    super.initState();
    Api.ingredientNames().then((names) {
      if (mounted) setState(() => _availableIngredients = names);
    });
    _updateCount();
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  /// Conta no backend quantas receitas os filtros atuais retornam.
  Future<void> _updateCount() async {
    final request = ++_countRequest;
    setState(() => _count = null);
    final f = _filters;
    final recipes = await Api.recipes(
      mealTypes: f.refeicoes.isEmpty ? null : f.refeicoes.toList(),
      minPrepTime: f.minPrepTime,
      maxPrepTime: f.maxPrepTime,
      ingredients: f.ingredientes.isEmpty ? null : f.ingredientes.toList(),
    );
    // Ignora respostas de cliques anteriores que chegaram depois.
    if (mounted && request == _countRequest) {
      setState(() => _count = recipes.length);
    }
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
    _updateCount();
  }

  void _clearFilters() {
    setState(() {
      _selectedTimes.clear();
      _selectedMeals.clear();
      _selectedIngredients.clear();
      _ingredientController.clear();
    });
    _updateCount();
  }

  void _applyFilters() {
    Navigator.pop(context, _filters);
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
            if (_availableIngredients.isEmpty)
              const Center(child: CircularProgressIndicator(color: verde))
            else
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
        count: _count,
      ),
    );
  }
}
