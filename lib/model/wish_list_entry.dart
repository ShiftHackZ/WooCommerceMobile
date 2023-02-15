class WishListEntry {
  final itemId;
  final productId;
  final dateAdded;

  WishListEntry.fromJson(Map<String, dynamic> json)
    : itemId = json['item_id'],
      productId = json['product_id'],
      dateAdded = json['date_added'];
}
