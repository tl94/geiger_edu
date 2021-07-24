// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lessonCategoryObj.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LessonCategoryAdapter extends TypeAdapter<LessonCategory> {
  @override
  final int typeId = 4;

  @override
  LessonCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LessonCategory(
      lessonCategoryId: fields[0] as String,
      title: (fields[1] as Map).cast<String, String>(),
      path: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LessonCategory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.lessonCategoryId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
