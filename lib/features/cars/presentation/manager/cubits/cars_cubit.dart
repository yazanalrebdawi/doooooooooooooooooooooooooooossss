import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/car_model.dart';

class CarsState {
  final String selectedCategory;
  final List<CarModel> cars;
  final List<String> categories;
  final List<String> brands;

  CarsState({
    required this.selectedCategory,
    required this.cars,
    required this.categories,
    required this.brands,
  });

  CarsState copyWith({
    String? selectedCategory,
    List<CarModel>? cars,
    List<String>? categories,
    List<String>? brands,
  }) {
    return CarsState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      cars: cars ?? this.cars,
      categories: categories ?? this.categories,
      brands: brands ?? this.brands,
    );
  }
}

class CarsCubit extends Cubit<CarsState> {
  CarsCubit()
      : super(CarsState(
          selectedCategory: 'All',
          categories: [
            'All', 'New Cars', 'Used Cars', 'Recommended cars', 'Featured',
          ],
          brands: [
            'BMW', 'Audi', 'VW', 'Mercedes', 'Toyota', 'Suzuki', 'Nissan',
          ],
          cars: [
            CarModel(
              id: '1',
              name: 'Toyota Supra',
              brand: 'Toyota',
              imageAsset: 'assets/images/bmwM3.png',
              rating: 4.8,
              reviews: 120,
              price: '2,500,000 L.E',
              isFavorite: true,
            ),
            CarModel(
              id: '2',
              name: 'Suzuki Swift',
              brand: 'Suzuki',
              imageAsset: 'assets/images/fake_img.jpg',
              rating: 4.1,
              reviews: 80,
              price: '500,000 L.E',
              isFavorite: false,
            ),
            CarModel(
              id: '3',
              name: 'Mercedes G-Class',
              brand: 'Mercedes',
              imageAsset: 'assets/images/on_boarding_1.png',
              rating: 4.9,
              reviews: 200,
              price: '3,000,000 L.E',
              isFavorite: false,
            ),
            CarModel(
              id: '4',
              name: 'BMW X5',
              brand: 'BMW',
              imageAsset: 'assets/images/on_boarding_2.png',
              rating: 4.7,
              reviews: 150,
              price: '1,800,000 L.E',
              isFavorite: true,
            ),
          ],
        ));

  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }
} 