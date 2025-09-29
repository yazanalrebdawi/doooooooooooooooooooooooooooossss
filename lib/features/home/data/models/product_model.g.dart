// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 2;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as int,
      name: fields[1] as String,
      price: fields[2] as double,
      description: fields[3] as String,
      imageUrl: fields[4] as String,
      images: (fields[5] as List).cast<String>(),
      category: fields[6] as String,
      location: fields[7] as String,
      rating: fields[8] as double,
      reviews: (fields[9] as List).cast<String>(),
      isFavorite: fields[10] as bool,
      sellerId: fields[11] as int,
      stock: fields[12] as int,
      discount: fields[13] as double,
      finalPrice: fields[14] as double,
      condition: fields[15] as String,
      material: fields[16] as String,
      color: fields[17] as String,
      warranty: fields[18] as String,
      installationInfo: fields[19] as String,
      createdAt: fields[20] as String,
      dealer: fields[21] as int,
      seller: (fields[22] as Map).cast<String, dynamic>(),
      locationText: fields[23] as String,
      locationCoords: (fields[24] as Map?)?.cast<String, dynamic>(),
      availabilityText: fields[25] as String,
      isInStock: fields[26] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(27)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.images)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.rating)
      ..writeByte(9)
      ..write(obj.reviews)
      ..writeByte(10)
      ..write(obj.isFavorite)
      ..writeByte(11)
      ..write(obj.sellerId)
      ..writeByte(12)
      ..write(obj.stock)
      ..writeByte(13)
      ..write(obj.discount)
      ..writeByte(14)
      ..write(obj.finalPrice)
      ..writeByte(15)
      ..write(obj.condition)
      ..writeByte(16)
      ..write(obj.material)
      ..writeByte(17)
      ..write(obj.color)
      ..writeByte(18)
      ..write(obj.warranty)
      ..writeByte(19)
      ..write(obj.installationInfo)
      ..writeByte(20)
      ..write(obj.createdAt)
      ..writeByte(21)
      ..write(obj.dealer)
      ..writeByte(22)
      ..write(obj.seller)
      ..writeByte(23)
      ..write(obj.locationText)
      ..writeByte(24)
      ..write(obj.locationCoords)
      ..writeByte(25)
      ..write(obj.availabilityText)
      ..writeByte(26)
      ..write(obj.isInStock);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
