import 'dart:convert';

import 'package:http/http.dart' as http;

/// Cliente GraphQL do backend NutriViver (Render).
/// Para apontar para outro servidor: flutter run --dart-define=API_URL=http://10.0.2.2:8080/graphql
class Api {
  static const String url = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://nutriviver-backend-latest.onrender.com/graphql',
  );

  /// Token da sessão (signUp/login). Fica só em memória: fechar o app pede login de novo.
  static String? token;

  static const String recipeFields = '''
    id name description prepTime imageUrl difficulty mealType steps calories protein favorite
    ingredients { quantity measureUnity ingredient { name } }
  ''';

  static const String _userFields =
      'id name goal { name } preferences { name } restrictions { name }';

  static const String _planFields =
      'id day time mealType note done recipe { $recipeFields }';

  /// Tipos de refeição aceitos pelo backend.
  static const List<String> mealTypes = [
    'Café da manhã',
    'Almoço',
    'Jantar',
    'Lanche',
    'Sobremesa',
  ];

  /// Dia no formato do backend (AAAA-MM-DD), sempre no fuso do aparelho.
  static String day(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  static DateTime parseDay(String value) => DateTime.parse(value);

  static Future<Map<String, dynamic>> query(String query,
      [Map<String, dynamic> variables = const {}]) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'query': query, 'variables': variables}),
    );
    final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final errors = body['errors'] as List?;
    if (errors != null && errors.isNotEmpty) {
      throw ApiException(errors.first['message'] as String);
    }
    return body['data'] as Map<String, dynamic>;
  }

  static List<Map<String, dynamic>> _list(dynamic value) =>
      List<Map<String, dynamic>>.from(value as List);

  // ---------- Conta ----------

  static Future<Map<String, dynamic>> signUp(String name, String password) async {
    final data = await query(
      r'mutation($n: String!, $p: String!) { signUp(name: $n, password: $p) { token user { id name } } }',
      {'n': name, 'p': password},
    );
    token = data['signUp']['token'] as String;
    return data['signUp']['user'];
  }

  /// Retorna null se usuário ou senha estiverem errados.
  static Future<Map<String, dynamic>?> login(String name, String password) async {
    final data = await query(
      r'mutation($n: String!, $p: String!) { login(name: $n, password: $p) { token user { id name } } }',
      {'n': name, 'p': password},
    );
    final result = data['login'] as Map<String, dynamic>?;
    if (result == null) return null;
    token = result['token'] as String;
    return result['user'];
  }

  static Future<void> logout() async {
    try {
      await query('mutation { logout }');
    } finally {
      token = null;
    }
  }

  static Future<Map<String, dynamic>> me() async {
    final data = await query('{ me { $_userFields } }');
    return data['me'];
  }

  static Future<void> updateProfile({
    String? goal,
    required List<String> preferences,
    required List<String> restrictions,
  }) async {
    await query(
      r'mutation($g: String, $p: [String!], $r: [String!]) { '
      r'updateProfile(goal: $g, preferences: $p, restrictions: $r) { id } }',
      {'g': goal, 'p': preferences, 'r': restrictions},
    );
  }

  /// Catálogos para a tela de preferências.
  static Future<Map<String, List<String>>> profileOptions() async {
    final data = await query(
        '{ goals { name } restrictions { name } preferences { name } }');
    List<String> names(String key) =>
        _list(data[key]).map((e) => e['name'] as String).toList();
    return {
      'goals': names('goals'),
      'restrictions': names('restrictions'),
      'preferences': names('preferences'),
    };
  }

  // ---------- Receitas ----------

  static Future<List<Map<String, dynamic>>> recipes({
    List<String>? mealTypes,
    double? minPrepTime,
    double? maxPrepTime,
    List<String>? ingredients,
  }) async {
    final data = await query(
      r'query($m: [String!], $min: Float, $max: Float, $i: [String!]) { '
              r'recipes(mealTypes: $m, minPrepTime: $min, maxPrepTime: $max, ingredients: $i) { ' +
          recipeFields +
          ' } }',
      {'m': mealTypes, 'min': minPrepTime, 'max': maxPrepTime, 'i': ingredients},
    );
    return _list(data['recipes']);
  }

  static Future<List<Map<String, dynamic>>> searchRecipes(String text) async {
    final data = await query(
      r'query($t: String!) { searchRecipes(text: $t) { ' + recipeFields + ' } }',
      {'t': text},
    );
    return _list(data['searchRecipes']);
  }

  static Future<List<Map<String, dynamic>>> recommendedRecipes(int limit) async {
    final data = await query(
      r'query($l: Int) { recommendedRecipes(limit: $l) { ' + recipeFields + ' } }',
      {'l': limit},
    );
    return _list(data['recommendedRecipes']);
  }

  static Future<List<String>> ingredientNames() async {
    final data = await query('{ ingredients { name } }');
    return _list(data['ingredients']).map((e) => e['name'] as String).toList();
  }

  /// Retorna o novo estado (true = favorita).
  static Future<bool> toggleFavorite(String recipeId) async {
    final data = await query(
        r'mutation($r: ID!) { toggleFavorite(recipeId: $r) }', {'r': recipeId});
    return data['toggleFavorite'] as bool;
  }

  // ---------- Cardápio ----------

  static Future<List<Map<String, dynamic>>> plan(DateTime from, DateTime to) async {
    final data = await query(
      r'query($a: String!, $b: String!) { plan(from: $a, to: $b) { ' + _planFields + ' } }',
      {'a': day(from), 'b': day(to)},
    );
    return _list(data['plan']);
  }

  static Future<void> addToPlan({
    required String recipeId,
    required DateTime date,
    required String time,
    required String mealType,
    String? note,
  }) async {
    await query(
      r'mutation($r: ID!, $d: String!, $t: String!, $m: String!, $n: String) { '
      r'addToPlan(recipeId: $r, day: $d, time: $t, mealType: $m, note: $n) { id } }',
      {'r': recipeId, 'd': day(date), 't': time, 'm': mealType, 'n': note},
    );
  }

  static Future<void> updatePlanItem(
    String id, {
    String? recipeId,
    DateTime? date,
    String? time,
    String? mealType,
    String? note,
    bool? done,
  }) async {
    await query(
      r'mutation($id: ID!, $r: ID, $d: String, $t: String, $m: String, $n: String, $done: Boolean) { '
      r'updatePlanItem(id: $id, recipeId: $r, day: $d, time: $t, mealType: $m, note: $n, done: $done) { id } }',
      {
        'id': id,
        'r': recipeId,
        'd': date == null ? null : day(date),
        't': time,
        'm': mealType,
        'n': note,
        'done': done,
      },
    );
  }

  static Future<void> removePlanItem(String id) async {
    await query(r'mutation($id: ID!) { removePlanItem(id: $id) }', {'id': id});
  }

  // ---------- Água e progresso ----------

  static Future<int> water(DateTime date) async {
    final data =
        await query(r'query($d: String!) { water(day: $d) }', {'d': day(date)});
    return data['water'] as int;
  }

  static Future<int> addWater(DateTime date, int ml) async {
    final data = await query(
        r'mutation($d: String!, $ml: Int!) { addWater(day: $d, ml: $ml) }',
        {'d': day(date), 'ml': ml});
    return data['addWater'] as int;
  }

  static Future<Map<String, dynamic>> stats(DateTime from, DateTime to) async {
    final data = await query(
      r'query($a: String!, $b: String!) { stats(from: $a, to: $b) { '
      r'planned done recipesTried daysWithPlan daysOnPlan fruitVegPerDay variety days { day planned done } } }',
      {'a': day(from), 'b': day(to)},
    );
    return data['stats'];
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}
