import 'package:wooapp/model/woo_image.dart';

class Category {
  int id;
  String name;
  String slug;
  int parent;
  String description;
  String image;
  int count;

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        slug = json['slug'],
        parent = json['parent'],
        description = json['description'],
        image = (json['image'] != null)
            ? WooImage.fromJson(json['image']).src
            : '',
        count = json['count'];
}
