import 'package:hive/hive.dart';

part 'settingObj.g.dart';

@HiveType(typeId: 1)
class Setting {

  @HiveField(0)
  bool darkmode;

  @HiveField(1)
  String language;

  Setting({
    required this.darkmode,
    required this.language
  });
}