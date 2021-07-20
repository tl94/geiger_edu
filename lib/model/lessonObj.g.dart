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
      completed: fields[1] as bool,
      recommended: fields[2] as bool?,
      apiUrl: fields[3] as String?,
      lastIndex: fields[4] as int,
      maxIndex: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Lesson obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.completed)
      ..writeByte(2)
      ..write(obj.recommended)
      ..writeByte(3)
      ..write(obj.apiUrl)
      ..writeByte(4)
      ..write(obj.lastIndex)
      ..writeByte(5)
      ..write(obj.maxIndex);
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
