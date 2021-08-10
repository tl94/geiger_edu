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
      parentMsgId: fields[3] as String?,
      childMsgIds: (fields[4] as List?)?.cast<String>(),
      lessonId: fields[5] as String,
      userId: fields[6] as String,
      imageId: fields[7] as String?,
      imageFilePath: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Comment obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.parentMsgId)
      ..writeByte(4)
      ..write(obj.childMsgIds)
      ..writeByte(5)
      ..write(obj.lessonId)
      ..writeByte(6)
      ..write(obj.userId)
      ..writeByte(7)
      ..write(obj.imageId)
      ..writeByte(8)
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
