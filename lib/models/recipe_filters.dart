class RecipeFilters {
  final Set<String> tempos;
  final Set<String> refeicoes;
  final Set<String> ingredientes;

  const RecipeFilters({
    required this.tempos,
    required this.refeicoes,
    required this.ingredientes,
  });

  static const RecipeFilters empty =
      RecipeFilters(tempos: {}, refeicoes: {}, ingredientes: {});

  /// Faixas (min, max) em minutos de cada opção de tempo da tela de filtros.
  static const Map<String, List<double?>> timeRanges = {
    'Até 15 min': [null, 15],
    '15 a 30 min': [15, 30],
    '30 a 45 min': [30, 45],
    'Mais de 45 min': [45, null],
  };

  bool get isEmpty => tempos.isEmpty && refeicoes.isEmpty && ingredientes.isEmpty;

  /// Menor tempo mínimo entre as faixas escolhidas (null = sem limite).
  double? get minPrepTime {
    if (tempos.isEmpty) return null;
    final mins = tempos.map((t) => timeRanges[t]![0]).toList();
    if (mins.contains(null)) return null;
    return mins.cast<double>().reduce((a, b) => a < b ? a : b);
  }

  /// Maior tempo máximo entre as faixas escolhidas (null = sem limite).
  double? get maxPrepTime {
    if (tempos.isEmpty) return null;
    final maxes = tempos.map((t) => timeRanges[t]![1]).toList();
    if (maxes.contains(null)) return null;
    return maxes.cast<double>().reduce((a, b) => a > b ? a : b);
  }
}
