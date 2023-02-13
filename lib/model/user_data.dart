class UserData {
  int id;
  String name;
  String role;

  UserData.fromJson(Map<String, dynamic> json)
      : id = int.tryParse(json['user_id']) ?? -1,
        name = json['display_name'],
        role = json['role'];
}
