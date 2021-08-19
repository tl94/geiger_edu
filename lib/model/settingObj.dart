import 'package:hive/hive.dart';

part 'settingObj.g.dart';

/// This class models a settings object.
///
/// @author Felix Mayer
/// @author Turan Ledermann

@HiveType(typeId: 1)
class Setting {

  @HiveField(0)
  bool darkmode;

  @HiveField(1)
  String language;

  /// Settings object constructor.
  Setting({
    required this.darkmode,
    required this.language
  });
}