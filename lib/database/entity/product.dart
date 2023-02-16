import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 2)
class ViewedProduct {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String price;
  @HiveField(3)
  String image;

  ViewedProduct(this.id, this.name, this.price, this.image);
}
