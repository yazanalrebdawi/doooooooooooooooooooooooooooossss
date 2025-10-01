// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteModelAdapter extends TypeAdapter<FavoriteModel> {
  @override
  final int typeId = 7;

  @override
  FavoriteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteModel(
      id: fields[0] as int,
      createdAt: fields[1] as DateTime,
      targetType: fields[2] as String,
      targetId: fields[3] as int,
      target: fields[4] as TargetModel,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.targetType)
      ..writeByte(3)
      ..write(obj.targetId)
      ..writeByte(4)
      ..write(obj.target);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TargetModelAdapter extends TypeAdapter<TargetModel> {
  @override
  final int typeId = 8;

  @override
  TargetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TargetModel(
      id: fields[0] as int,
      name: fields[1] as String,
      brand: fields[2] as String,
      model: fields[3] as String,
      price: fields[4] as String,
      discount: fields[5] as String,
      finalPrice: fields[6] as String,
      createdAt: fields[7] as DateTime,
      mainImage: fields[8] as String,
      category: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TargetModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.brand)
      ..writeByte(3)
      ..write(obj.model)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.discount)
      ..writeByte(6)
      ..write(obj.finalPrice)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.mainImage)
      ..writeByte(9)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TargetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
