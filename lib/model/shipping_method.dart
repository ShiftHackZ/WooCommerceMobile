class ShippingMethod {
  String id;
  String title;
  String description;

  ShippingMethod.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      title = json['title'],
      description = json['description'];
}
