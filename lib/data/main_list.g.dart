// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MainListDataAdapter extends TypeAdapter<MainListData> {
  @override
  final int typeId = 1;

  @override
  MainListData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MainListData(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MainListData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.host)
      ..writeByte(2)
      ..write(obj.port);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainListDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
