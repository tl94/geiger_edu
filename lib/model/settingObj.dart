import 'package:hive/hive.dart';

part 'settingObj.g.dart';

@HiveType(typeId: 1)
class Setting {

  @HiveField(0)
  bool darkmode;

  @HiveField(1)
  bool showAlias;

  @HiveField(2)
  bool showScore;

  @HiveField(3)
  String language;

  Setting({
    required this.darkmode,
    required this.showAlias,
    required this.showScore,
    required this.language
  });
}