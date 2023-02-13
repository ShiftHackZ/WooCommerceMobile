class WooGeoShop {
  int id;
  double lat;
  double lng;
  String name;

  WooGeoShop.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      lat = json['lat'],
      lng = json['lng'],
      name = json['name'];
}
