// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarModelAdapter extends TypeAdapter<CarModel> {
  @override
  final int typeId = 0;

  @override
  CarModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CarModel(
      id: fields[0] as int,
      name: fields[1] as String,
      imageUrl: fields[2] as String,
      price: fields[3] as double,
      isNew: fields[4] as bool,
      location: fields[5] as String,
      mileage: fields[6] as String,
      year: fields[7] as int,
      transmission: fields[8] as String,
      engine: fields[9] as String,
      fuelType: fields[10] as String,
      color: fields[11] as String,
      doors: fields[12] as int,
      sellerNotes: fields[13] as String,
      sellerName: fields[14] as String,
      sellerType: fields[15] as String,
      sellerImage: fields[16] as String,
      dealerId: fields[17] as int,
      brand: fields[18] as String,
      isFavorite: fields[19] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CarModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.isNew)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.mileage)
      ..writeByte(7)
      ..write(obj.year)
      ..writeByte(8)
      ..write(obj.transmission)
      ..writeByte(9)
      ..write(obj.engine)
      ..writeByte(10)
      ..write(obj.fuelType)
      ..writeByte(11)
      ..write(obj.color)
      ..writeByte(12)
      ..write(obj.doors)
      ..writeByte(13)
      ..write(obj.sellerNotes)
      ..writeByte(14)
      ..write(obj.sellerName)
      ..writeByte(15)
      ..write(obj.sellerType)
      ..writeByte(16)
      ..write(obj.sellerImage)
      ..writeByte(17)
      ..write(obj.dealerId)
      ..writeByte(18)
      ..write(obj.brand)
      ..writeByte(19)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
