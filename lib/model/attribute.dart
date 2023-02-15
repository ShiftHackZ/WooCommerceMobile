class ProductAttribute {
  int id;
  String name;
  int? position;
  bool? visible;
  bool? variation;
  List<String> options;

  ProductAttribute.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        position = json['position'],
        visible = json['visible'],
        variation = json['variation'],
        options = (json['options'] as List?)
            ?.map((option) => option.toString())
            .toList() ?? [];
}

class Attribute {
  int id;
  String name;
  String slug;
  String type;
  String orderBy;
  bool hasArchives;

  Attribute.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        slug = json['slug'],
        type = json['type'],
        orderBy = json['order_by'],
        hasArchives = json['has_archives'];
}

class Term {
  int id;
  String name;
  String slug;
  String description;
  int menuOrder;
  int count;

  Term.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        slug = json['slug'],
        description = json['description'],
        menuOrder = json['menu_order'],
        count = json['count'];
}
