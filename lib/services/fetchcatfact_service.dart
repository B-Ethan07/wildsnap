import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wildsnap/models/cat_facts.dart';

Future<CatFact> fetchCatFacts({int count = 1}) async {
  final uri = Uri.parse('https://meowfacts.herokuapp.com/');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final datas = jsonDecode(response.body) as Map<String, dynamic>;
    return CatFact.fromJson(datas);
  } else {
    throw Exception('Failed to load the api meow facts');
  }
}
