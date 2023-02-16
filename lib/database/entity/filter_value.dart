import 'package:hive/hive.dart';

part 'filter_value.g.dart';

@HiveType(typeId: 4)
class FilterValue {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String slug;

  FilterValue(this.id, this.name, this.slug);
}
