
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String role;
  @HiveField(3)
  String login;
  @HiveField(4)
  String password;
  @HiveField(5)
  String email;

  User(this.id, this.name, this.role, this.login, this.password, this.email);
}
