// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'difficultyLevelObj.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DifficultyLevelAdapter extends TypeAdapter<DifficultyLevel> {
  @override
  final int typeId = 5;

  @override
  DifficultyLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DifficultyLevel.beginner;
      case 1:
        return DifficultyLevel.advanced;
      case 2:
        return DifficultyLevel.master;
      default:
        return DifficultyLevel.beginner;
    }
  }

  @override
  void write(BinaryWriter writer, DifficultyLevel obj) {
    switch (obj) {
      case DifficultyLevel.beginner:
        writer.writeByte(0);
        break;
      case DifficultyLevel.advanced:
        writer.writeByte(1);
        break;
      case DifficultyLevel.master:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DifficultyLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
