class Tax {
  int id;
  String total;
  String subTotal;

  Tax.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      total = json['total'],
      subTotal = json['subtotal'];
}
