import 'package:flutter/material.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    const greenColor = Color(0xFF16C768);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Título + Botão Filtro Lateral
              _buildHeader(),
              const SizedBox(height: 24),

              // Campo de Busca
              _searchRecipes(),
              const SizedBox(height: 16),

              // Chips de Filtro
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildActiveFilterChip(
                      icon: Icons.tune,
                      label: 'Filtros',
                      greenColor: greenColor,
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(label: 'Tempo'),
                    const SizedBox(width: 8),
                    _buildFilterChip(label: 'Tipo de refeição'),
                    const SizedBox(width: 8),
                    _buildFilterChip(label: 'Ingredientes'),
                  ],
                ),
              ),
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
                    _buildRecipeCard(
                      title: 'Omelete de forno',
                      time: '15 min',
                      difficulty: 'Fácil',
                      imageUrl:
                      'https://images.unsplash.com/photo-1510693206972-df098062cb71?auto=format&fit=crop&w=500&q=80',
                    ),
                    const SizedBox(width: 16),
                    _buildRecipeCard(
                      title: 'Wrap de frango',
                      time: '20 min',
                      difficulty: 'Fácil',
                      imageUrl:
                      'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?auto=format&fit=crop&w=500&q=80',
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
                  _CategoryTile(
                    label: 'Café da manhã',
                    iconWidget: Icon(Icons.wb_sunny_outlined, color: Colors.amber),
                  ),
                  _CategoryTile(
                    label: 'Almoço',
                    iconWidget: Text('🍽️', style: TextStyle(fontSize: 18)),
                  ),
                  _CategoryTile(
                    label: 'Jantar',
                    iconWidget: Text('🌙', style: TextStyle(fontSize: 18)),
                  ),
                  _CategoryTile(
                    label: 'Lanches',
                    iconWidget: Text('🥪', style: TextStyle(fontSize: 18)),
                  ),
                  _CategoryTile(
                    label: 'Sobremesas',
                    iconWidget: Text('🍰', style: TextStyle(fontSize: 18)),
                  ),
                  _CategoryTile(
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

  Widget _buildHeader() {

    return Row(
        children: [

          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Título + Botão Filtro Lateral
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Receitas',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1C1E),
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F5F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.tune,
                            color: Color(0xFF1A1C1E),
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ))]);
  }

  TextField _searchRecipes(){
    return TextField(
        decoration: InputDecoration(
          hintText: 'Buscar receitas, ingredientes...',
          hintStyle: const TextStyle(
            color: Color(0xFF9EA5B1),
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF9EA5B1),
          ),
          filled: true,
          fillColor: const Color(0xFFF8F9FA),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE1E5EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF16C768),
          ),
        ),
        ));
}
  // Chip Ativo (Filtros verde)
  Widget _buildActiveFilterChip({
    required IconData icon,
    required String label,
    required Color greenColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: greenColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: greenColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: greenColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: greenColor,
            ),
          ),
        ],
      ),
    );
  }

  // Chip Inativo
  Widget _buildFilterChip({required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1E5EB)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF697386),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Card de Receita
  Widget _buildRecipeCard({
    required String title,
    required String time,
    required String difficulty,
    required String imageUrl,
  }) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E5EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem com Favorito
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  imageUrl,
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 16,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1A1C1E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 3,
                      backgroundColor: Color(0xFF697386),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF697386),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '•',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF697386),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      difficulty,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF16C768),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget da Categoria
class _CategoryTile extends StatelessWidget {
  final String label;
  final Widget iconWidget;

  const _CategoryTile({
    required this.label,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          iconWidget,
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1C1E),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}