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
      lessonCategoryId: fields[1] as String,
      title: (fields[2] as Map).cast<String, String>(),
      recommended: fields[3] as bool,
      motivation: (fields[4] as Map).cast<String, String>(),
      duration: fields[5] as int,
      difficulty: fields[6] as Difficulty,
      lastIndex: fields[7] as int,
      maxIndex: fields[8] as int,
      hasQuiz: fields[9] as bool,
      completed: fields[10] as bool,
      path: fields[11] as String,
      lastQuizScore: fields[12] as int,
      maxQuizScore: fields[13] as int,
      apiUrl: fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Lesson obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.lessonId)
      ..writeByte(1)
      ..write(obj.lessonCategoryId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.recommended)
      ..writeByte(4)
      ..write(obj.motivation)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.difficulty)
      ..writeByte(7)
      ..write(obj.lastIndex)
      ..writeByte(8)
      ..write(obj.maxIndex)
      ..writeByte(9)
      ..write(obj.hasQuiz)
      ..writeByte(10)
      ..write(obj.completed)
      ..writeByte(11)
      ..write(obj.path)
      ..writeByte(12)
      ..write(obj.lastQuizScore)
      ..writeByte(13)
      ..write(obj.maxQuizScore)
      ..writeByte(14)
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
