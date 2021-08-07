// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commentObj.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommentAdapter extends TypeAdapter<Comment> {
  @override
  final int typeId = 6;

  @override
  Comment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Comment(
      id: fields[0] as String,
      text: fields[1] as String,
      dateTime: fields[2] as DateTime,
      reply: fields[3] as bool,
      lessonId: fields[4] as String,
      userId: fields[5] as String,
      imageFilePath: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Comment obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.reply)
      ..writeByte(4)
      ..write(obj.lessonId)
      ..writeByte(5)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.imageFilePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
