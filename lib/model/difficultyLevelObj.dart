import 'package:hive/hive.dart';

part 'difficultyLevelObj.g.dart';

@HiveType(typeId: 5)
enum DifficultyLevel {
  @HiveField(0)
  beginner,
  @HiveField(1)
  advanced,
  @HiveField(2)
  master
}
