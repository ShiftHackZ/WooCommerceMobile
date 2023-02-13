class WpRegResponse {
  int code;
  int id;
  String message;

  WpRegResponse.fromJson(Map<String, dynamic> json)
    : code = json['code'] ?? 500,
      id = json['id'] ?? -1,
      message = json['message'] ?? '';
}
