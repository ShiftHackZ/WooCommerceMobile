class CartResponse {
  bool isEmpty;
  String cartHash;
  String cartKey;
  List<CartItem> items;
  Totals totals;

  CartResponse.fromJson(Map<String, dynamic> json)
    : isEmpty = false,
      cartHash = json['cart_hash'],
      cartKey = json['cart_key'],
      items = (json['items'] as List).map((item) => CartItem.fromJson(item)).toList(),
      totals = Totals.fromJson(json['totals']);

  CartResponse.empty()
    : isEmpty = true,
      cartHash = '',
      cartKey = '',
      items = [],
      totals = Totals.empty();
}

class CartItem {
  String itemKey;
  int id;
  String name;
  String title;
  double price;
  CartQuantity quantity;
  CartTotals totals;
  String slug;
  String featuredImage;

  CartItem.fromJson(Map<String, dynamic> json)
    : itemKey = json['item_key'],
      id = json['id'],
      name = json['name'],
      title = json['title'],
      price = double.tryParse(json['price'].toString()) ?? 0.0,
      quantity = CartQuantity.fromJson(json['quantity']),
      totals = CartTotals.fromJson(json['totals']),
      slug = json['slug'],
      featuredImage = json['featured_image'];
}

class Totals {
  String total;

  Totals.fromJson(Map<String, dynamic> json)
    : total = json['total'];

  Totals.empty()
    : total = "";
}

class CartTotals {
  String subtotal;
  int subtotalTax;
  double total;
  int tax;

  CartTotals.fromJson(Map<String, dynamic> json)
    : subtotal = json['subtotal'] ?? '',
      subtotalTax = json['subtotal_tax'] ?? '',
      total = json['total'] ?? '',
      tax = json['tax'] ?? '';
}

class CartQuantity {
  int value;
  int minPurchase;
  int maxPurchase;

  CartQuantity.fromJson(Map<String, dynamic> json)
    : value = json['value'],
      minPurchase = json['min_purchase'],
      maxPurchase = json['max_purchase'];
}
