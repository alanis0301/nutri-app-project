import 'package:flutter/material.dart';
import 'package:nutri_app_project/widgets/recipes/recipe_details/bottom_button.dart';
import '../widgets/recipes/recipe_details/recipe_image.dart';
import '../widgets/recipes/recipe_details/recipe_information.dart';
import '../widgets/recipes/recipe_details/tabs.dart';
import '../widgets/recipes/recipe_details/tab_content.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  // Estado da tela
  bool isFavorite = false;
  int selectedTab = 0;

  final List<String> ingredients = [
    '2 filés de salmão (200g cada)',
    '1 batata-doce média',
    '1 xícara de brócolis',
    '2 colheres de azeite de oliva',
    'Sal e pimenta a gosto',
  ];

  late List<bool> checkedIngredients;

  @override
  void initState() {
    super.initState();
    checkedIngredients = List<bool>.filled(ingredients.length, true);
  }

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
                    const RecipeImage(),
                    const RecipeInformation(),
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
                    ),
                  ],
                ),
              ),
            ),

            // Botão fixo na parte inferior
            const BottomButton(),
          ],
        ),
      ),
    );
  }
}
