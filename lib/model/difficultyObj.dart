import 'package:hive/hive.dart';

part 'difficultyObj.g.dart';

@HiveType(typeId: 5)
enum Difficulty {
  @HiveField(0)
  beginner,
  @HiveField(1)
  advanced,
  @HiveField(2)
  master
}
