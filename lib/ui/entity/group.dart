import 'package:hive/hive.dart';
part 'group.g.dart';

@HiveType(typeId: 0)
class Group extends HiveObject {
  @HiveField(0)
  String name;

  Group({required this.name});
}
