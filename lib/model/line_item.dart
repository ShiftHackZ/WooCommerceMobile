import 'package:wooapp/model/tax.dart';

class LineItem {
  int id;
  String name;
  int productId;
  int variationId;
  int quantity;
  String taxClass;
  String subtotal;
  String subtotalTax;
  String total;
  String totalTax;
  List<Tax> taxes;
  String sku;
  double price;

  LineItem.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      productId = json['product_id'],
      variationId = json['variation_id'],
      quantity = json['quantity'],
      taxClass = json['tax_class'],
      subtotal = json['subtotal'],
      subtotalTax = json['subtotal_tax'],
      total = json['total'],
      totalTax = json['total_tax'],
      taxes = (json['taxes'] as List).map((item) => Tax.fromJson(item)).toList(),
      sku = json['sku'],
      price = double.tryParse(json['price'].toString()) ?? 0.0;
}
