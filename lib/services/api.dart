import 'dart:convert';

import 'package:http/http.dart' as http;

/// Cliente GraphQL do backend NutriViver (Render).
/// Para apontar para outro servidor: flutter run --dart-define=API_URL=http://10.0.2.2:8080/graphql
class Api {
  static const String url = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://nutriviver-backend-latest.onrender.com/graphql',
  );

  static const String _recipeFields = '''
    id name description prepTime imageUrl difficulty mealType steps
    ingredients { quantity measureUnity ingredient { name } }
  ''';

  static Future<Map<String, dynamic>> query(String query,
      [Map<String, dynamic> variables = const {}]) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query, 'variables': variables}),
    );
    final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final errors = body['errors'] as List?;
    if (errors != null && errors.isNotEmpty) {
      throw Exception(errors.first['message']);
    }
    return body['data'] as Map<String, dynamic>;
  }

  static Future<List<Map<String, dynamic>>> recipes() async {
    final data = await query('{ recipes { $_recipeFields } }');
    return List<Map<String, dynamic>>.from(data['recipes']);
  }

  static Future<List<Map<String, dynamic>>> searchRecipes(String text) async {
    final data = await query(
      r'query($t: String!) { searchRecipes(text: $t) { ' + _recipeFields + ' } }',
      {'t': text},
    );
    return List<Map<String, dynamic>>.from(data['searchRecipes']);
  }

  // ponytail: o app ainda não tem tela de login, então usa uma conta de demonstração.
  // Quando existir a tela, trocar por login()/signUp() com os dados digitados.
  static const _demoUser = 'demo';
  static const _demoPassword = 'nutriviver';
  static String? _userId;

  static const String _userFields =
      'id name goal { name } preferences { name } restrictions { name }';

  static Future<Map<String, dynamic>> currentUser() async {
    if (_userId != null) {
      final data = await query(
          r'query($id: ID!) { user(id: $id) { ' + _userFields + ' } }',
          {'id': _userId});
      return data['user'];
    }
    const vars = {'n': _demoUser, 'p': _demoPassword};
    var data = await query(
        r'mutation($n: String!, $p: String!) { login(name: $n, password: $p) { ' +
            _userFields +
            ' } }',
        vars);
    var user = data['login'] as Map<String, dynamic>?;
    if (user == null) {
      data = await query(
          r'mutation($n: String!, $p: String!) { signUp(name: $n, password: $p) { ' +
              _userFields +
              ' } }',
          vars);
      user = data['signUp'] as Map<String, dynamic>;
    }
    _userId = user['id'] as String;
    return user;
  }

  static Future<void> updateProfile({
    String? goal,
    required List<String> preferences,
    required List<String> restrictions,
  }) async {
    final user = await currentUser();
    await query(
      r'mutation($id: ID!, $g: String, $p: [String!], $r: [String!]) { '
      r'updateProfile(userId: $id, goal: $g, preferences: $p, restrictions: $r) { id } }',
      {'id': user['id'], 'g': goal, 'p': preferences, 'r': restrictions},
    );
  }
}
