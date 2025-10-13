class CatFact {
  final String fact;
  CatFact({required this.fact});

  factory CatFact.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    // si data est une liste d'élément et data n'est pas vide et que data est une chaine de caractère alors :
    if (data is List && data.isNotEmpty && data.first is String) {
      // convertis le premier element de type dynamic en chaine de caractère
      return CatFact(fact: data.first as String);
    }
    throw Exception('Invalid JSON: "data" should be a non-empty List<String>');
  }
}
