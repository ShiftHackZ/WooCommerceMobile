import 'package:wooapp/model/attribute.dart';
import 'package:wooapp/model/category.dart';
import 'package:wooapp/model/dimensions.dart';
import 'package:wooapp/model/woo_image.dart';

class Product {
  int id;
  String name;
  String permalink;
  String price;
  String regularPrice;
  String salePrice;
  String description;
  String dateCreated;
  String dateModified;
  String type;
  String status;
  String stockStatus;
  int stockCount;
  String sku;
  double rating;
  Dimensions dimensions;
  List<WooImage> images;
  List<ProductAttribute> attributes;
  List<Category> categories;

  bool get isVariable => type == 'variable';
  bool get hasDescription => description.isNotEmpty;

  Product.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      permalink = json['permalink'],
      price = json['price'],
      regularPrice = json['regular_price'],
      salePrice = json['sale_price'],
      description = json['description'],
      dateCreated = json['date_created'],
      dateModified = json['date_modified'],
      type = json['type'],
      status = json['status'],
      stockStatus = json['stock_status'],
      stockCount = json['stock_quantity'] ?? -1,
      sku = json['sku'] ?? '',
      rating = double.tryParse(json['average_rating']) ?? 0.0,
      dimensions = Dimensions.fromJson(json['dimensions']),
      images = (json['images'] as List?)?.map((i) => WooImage.fromJson(i)).toList() ?? [],
      attributes = (json['attributes'] as List?)?.map((a) => ProductAttribute.fromJson(a)).toList() ?? [],
      categories = (json['categories'] as List?)?.map((c) => Category.fromJson(c)).toList() ?? [];
}

class CategoryProduct {
  int id;
  String name;
  String slug;
  String permalink;
  String price;
  String regularPrice;
  String salePrice;
  String image;

  CategoryProduct.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      slug = json['slug'],
      permalink = json['permalink'],
      price = json['price'],
      regularPrice = json['regular_price'],
      salePrice = json['sale_price'],
      image = json['image'];
}
