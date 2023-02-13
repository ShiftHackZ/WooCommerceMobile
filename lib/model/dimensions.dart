class Dimensions {
  String length;
  String width;
  String height;

  Dimensions.fromJson(Map<String, dynamic> json)
      : length = json['length'],
        width = json['width'],
        height = json['height'];
}
