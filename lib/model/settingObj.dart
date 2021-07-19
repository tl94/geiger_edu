import 'package:hive/hive.dart';

part 'settingObj.g.dart';

@HiveType(typeId: 1)
class Setting {

  @HiveField(0)
  final bool darkmode;

  @HiveField(1)
  final bool showAlias;

  @HiveField(2)
  final bool showScore;

  Setting({
    required this.darkmode,
    required this.showAlias,
    required this.showScore,
  });
}