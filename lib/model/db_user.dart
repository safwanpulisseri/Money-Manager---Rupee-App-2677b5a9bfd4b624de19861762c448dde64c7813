import 'package:hive/hive.dart';

part 'db_user.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? imagePath;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String country;

  UserModel(
      {required this.id,
      this.imagePath,
      required this.name,
      required this.country});
}
