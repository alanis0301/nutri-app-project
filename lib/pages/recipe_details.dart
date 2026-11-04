import 'package:flutter/material.dart';
import 'package:nutri_app_project/widgets/recipes/recipe_details/bottom_button.dart';
import '../widgets/recipes/recipe_details/recipe_image.dart';
import '../widgets/recipes/recipe_details/recipe_information.dart';
import '../widgets/recipes/recipe_details/tabs.dart';
import '../widgets/recipes/recipe_details/tab_content.dart';

class RecipeDetailPage extends StatefulWidget {
  /// Receita vinda do backend (mesmos campos de Api.recipeFields).
  final Map<String, dynamic> recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Conteúdo rolável
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RecipeImage(recipe: widget.recipe),
                    RecipeInformation(recipe: widget.recipe),
                    Tabs(
                      selectedTab: selectedTab,
                      onTabChanged: (index) {
                        setState(() {
                          selectedTab = index;
                        });
                      },
                    ),
                    TabContent(
                      selectedTab: selectedTab,
                      recipe: widget.recipe,
                    ),
                  ],
                ),
              ),
            ),

            // Botão fixo na parte inferior
            BottomButton(recipe: widget.recipe),
          ],
        ),
      ),
    );
  }
}
