class CarModel {
  final String id;
  final String name;
  final String brand;
  final String imageAsset;
  final double rating;
  final int reviews;
  final String price;
  final bool isFavorite;

  CarModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageAsset,
    required this.rating,
    required this.reviews,
    required this.price,
    this.isFavorite = false,
  });
} 