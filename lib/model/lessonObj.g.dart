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
      lessonId: fields[0] as String,
      name: fields[1] as String,
      recommended: fields[2] as bool,
      motivation: fields[3] as String,
      duration: fields[4] as int,
      difficulty: fields[5] as Difficulty,
      lastIndex: fields[6] as int,
      maxIndex: fields[7] as int,
      hasQuiz: fields[8] as bool,
      completed: fields[9] as bool,
      path: fields[10] as String,
      apiUrl: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Lesson obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.lessonId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.recommended)
      ..writeByte(3)
      ..write(obj.motivation)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.difficulty)
      ..writeByte(6)
      ..write(obj.lastIndex)
      ..writeByte(7)
      ..write(obj.maxIndex)
      ..writeByte(8)
      ..write(obj.hasQuiz)
      ..writeByte(9)
      ..write(obj.completed)
      ..writeByte(10)
      ..write(obj.path)
      ..writeByte(11)
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
