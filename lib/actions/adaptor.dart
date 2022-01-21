// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:hive/hive.dart';
import 'package:offlinestorage/models/hivemodel.dart';


// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************


class ServiceAdapter extends TypeAdapter<GetService> {
  @override
  final int typeId = 1;

  @override
  GetService read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GetService(
      name: fields[0] as String,
      lastname: fields[1] as String,
      status: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GetService obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.lastname)
      ..writeByte(2)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ServiceAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}