import 'package:hive/hive.dart';

part 'filter_active.g.dart';

@HiveType(typeId: 5)
class ActiveFilter {
  @HiveField(0)
  int id;
  @HiveField(1)
  String slug;
  @HiveField(2)
  List<int> termIds;

  ActiveFilter(this.id, this.slug, this.termIds);
}
