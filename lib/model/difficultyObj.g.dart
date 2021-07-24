// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'difficultyObj.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DifficultyAdapter extends TypeAdapter<Difficulty> {
  @override
  final int typeId = 5;

  @override
  Difficulty read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Difficulty.beginner;
      case 1:
        return Difficulty.advanced;
      case 2:
        return Difficulty.master;
      default:
        return Difficulty.beginner;
    }
  }

  @override
  void write(BinaryWriter writer, Difficulty obj) {
    switch (obj) {
      case Difficulty.beginner:
        writer.writeByte(0);
        break;
      case Difficulty.advanced:
        writer.writeByte(1);
        break;
      case Difficulty.master:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DifficultyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
