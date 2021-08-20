import 'package:hive/hive.dart';

part 'difficultyObj.g.dart';

/// This class models a difficulty object.
///
/// @author Felix Mayer
/// @author Turan Ledermann

@HiveType(typeId: 5)
enum Difficulty {
  @HiveField(0)
  beginner,
  @HiveField(1)
  advanced,
  @HiveField(2)
  master
}
