class WooImage {
  int id;
  String src;
  String name;
  String alt;

  WooImage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        src = json['src'],
        name = json['name'],
        alt = json['alt'];
}
