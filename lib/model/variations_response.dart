class Variation {
  final String slug;
  final String name;
  final List<Term> terms;

  Variation.fromJson(Map<String, dynamic> json)
    : slug = json['slug'],
      name = json['name'],
      terms = (json['terms'] as List).map((t) => Term.fromJson(t)).toList();
}

class Term {
  final String name;
  final String slug;

  Term.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      slug = json['slug'];
}
