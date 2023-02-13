import 'package:hive/hive.dart';
import 'package:untitled/database/filter_value.dart';

part 'filter.g.dart';

@HiveType(typeId: 3)
class Filter {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String slug;
  @HiveField(3)
  String type;
  @HiveField(4)
  List<FilterValue> values;

  Filter(this.id, this.name, this.slug, this.type, this.values);
}
