// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xApiObj.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class XApiObjAdapter extends TypeAdapter<XApiObj> {
  @override
  final int typeId = 2;

  @override
  XApiObj read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return XApiObj(
      mbox: fields[0] as String,
      name: fields[1] as String,
      verbId: fields[2] as String,
      display: (fields[3] as Map).cast<String, String>(),
      activityId: fields[4] as String,
      definitionType: fields[5] as String,
      definitionName: (fields[6] as Map).cast<String, String>(),
      definitionDescription: (fields[7] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, XApiObj obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.mbox)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.verbId)
      ..writeByte(3)
      ..write(obj.display)
      ..writeByte(4)
      ..write(obj.activityId)
      ..writeByte(5)
      ..write(obj.definitionType)
      ..writeByte(6)
      ..write(obj.definitionName)
      ..writeByte(7)
      ..write(obj.definitionDescription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is XApiObjAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
