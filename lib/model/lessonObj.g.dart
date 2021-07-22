// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lessonObj.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LessonAdapter extends TypeAdapter<Lesson> {
  @override
  final int typeId = 3;

  @override
  Lesson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lesson(
      name: fields[0] as String,
      recommended: fields[1] as bool,
      motivation: fields[2] as String,
      lengthInMinutes: fields[3] as int,
      difficultyLevel: fields[4] as DifficultyLevel,
      lastIndex: fields[5] as int,
      maxIndex: fields[6] as int,
      completed: fields[7] as bool,
      path: fields[8] as String,
      apiUrl: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Lesson obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.recommended)
      ..writeByte(2)
      ..write(obj.motivation)
      ..writeByte(3)
      ..write(obj.lengthInMinutes)
      ..writeByte(4)
      ..write(obj.difficultyLevel)
      ..writeByte(5)
      ..write(obj.lastIndex)
      ..writeByte(6)
      ..write(obj.maxIndex)
      ..writeByte(7)
      ..write(obj.completed)
      ..writeByte(8)
      ..write(obj.path)
      ..writeByte(9)
      ..write(obj.apiUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
