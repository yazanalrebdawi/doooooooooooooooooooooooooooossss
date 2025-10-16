// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dooss_business_app/user/core/utils/response_status_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/dashboard_info_model.dart';
import '../../data/models/data_profile_models.dart';
import '../../data/models/product_data_model.dart';
import '../../data/remouteData/home_page_state.dart';
import '../../data/remouteData/remoute_dealer_data_source.dart';

class HomePageCubit extends Cubit<HomepageState> {
  HomePageCubit(this.data)
      : super(
          HomepageState(
            dataStore: DataProfileModel(
              id: 0,
              name: '',
              storeDescription: '',
              reelsCount: 0,
              carsActive: 0,
              carsSold: 0,
              handle: '',
              phone: '',
              monthlyReelsLimit: 0,
              contactPhone: '',
              locationAddress: '',
              googleMapsLink: '',
              workingDays: [],
              openingTime: '',
              closingTime: '',
              isStoreOpen: true,
              storeStatus: '',
              latitude: 0,
              longitude: 0,
              storeLogo: '',
            ),
            isSuccessAddCar: false,
            allProduct: [],
            dataDash: DealerDashboardInfo(
              messages: Messages(messagesNew: 0),
              ratings: 0,
              reels: Reels(views: 0, likes: 0),
              cars:
                  Cars(active: 0, sold: 0, archived: 0, topRating: 0, list: []),
            ),
          ),
        );
  final RemouteDealerDataSource data;

  //?-------------------------------------------------------------

  void deleteAccount(String password, String reason) async {
    emit(state.copyWith(deleateAccount: ResponseStatusEnum.loading));

    final result = await data.deleteAccountRemote(
        currentPassword: password, reason: reason);

    result.fold(
      (failure) {
        emit(state.copyWith(
          deleateAccount: ResponseStatusEnum.failure,
          errorDeleteAccount: failure.message,
        ));
      },
      (_) {
        emit(state.copyWith(
          deleateAccount: ResponseStatusEnum.success,
        ));
      },
    );
  }

  //?-------------------------------------------------------------
  void getdataproduct() async {
    // emit(state.copyWith(isLoadingGetProduct: true));
    var result = await data.getDataProduct();
    result.fold(
      (error) {
        emit(state.copyWith(error: error.message, isLoadingGetProduct: false));
        print(error.toString());
      },
      (data) {
        // print(data.length);
        emit(state.copyWith(
            allProduct: data,
            isSuccessGetProduct: true,
            isLoadingGetProduct: false));
      },
    );
  }

  void addProduct(
    String product,
    String description,
    String price,
    String category,
    String discount,
    XFile? image,
  ) async {
    var result = await data.addProduct(
      product,
      description,
      price,
      category,
      discount,
      image!,
    );
    result.fold(
      (error) {
        print(error);
        emit(state.copyWith(error: error));
      },
      (data) {
        List<productdata> all = List.from(state.allProduct);
        print(all.length);

        all.add(
          productdata(
            id: data.id,
            name: data.name,
            price: data.price,
            discount: data.discount,
            finalPrice: data.finalPrice,
            mainImage: data.mainImage,
            category: data.category,
            isAvailable: true,
          ),
        );
        print(all.length);
        emit(state.copyWith(allProduct: all, isLoadingFecthProductData: true));
      },
    );
  }

  void deleteProduct(int id) async {
    List<productdata> all = List.from(state.allProduct);
    int index = all.indexWhere((item) => item.id == id);
    print(index);
    productdata deletedProduct = all[index];
    all.removeAt(index);
    emit(state.copyWith(allProduct: all));
    var result = await data.deleteProduct(id);
    result.fold((e) {
      all.insert(index, deletedProduct);
      emit(state.copyWith(allProduct: all));
    }, (data) {});
  }

  void toggleAvailableProduct(int id) async {
    List<productdata> allProduct = List.from(state.allProduct);
    int index = allProduct.indexWhere((item) => item.id == id);
    productdata CurrentProduct = allProduct[index];
    productdata editProduct = CurrentProduct.copyWith(
      isAvailable: !CurrentProduct.isAvailable,
    );
    // allReels.insert(index, editReel);
    allProduct[index] = editProduct;
    emit(state.copyWith(allProduct: allProduct));
    var result = await data.editAvailabilityProduct(
      id,
      !CurrentProduct.isAvailable,
    );
    result.fold((failure) {
      print(failure.message);
      allProduct[index] = CurrentProduct;
      emit(state.copyWith(allProduct: allProduct));
    }, (data) {});
  }

  void gatDataDashboard() async {
    var result = await data.getDataDashboard();
    result.fold((failure) {}, (dataResponse) {
      emit(state.copyWith(dataDash: dataResponse));
    });
  }

  void EditProduct(
    int id,
    String name,
    String price,
    String discount,
    bool isAvailable,
    String Category,
    XFile? image,
  ) async {
    var result = await data.editproductData(
      id,
      name,
      price,
      discount,
      isAvailable,
      Category,
      image,
    );
    result.fold(
      (error) {
        emit(state.copyWith(error: error.message));
      },
      (isSuccess) {
        print('success');
        emit(state.copyWith(isSuccessEditProduct: isSuccess));
      },
    );
  }

  void AddNewCar(
      String brand,
      int year,
      String model,
      String price,
      String milleage,
      String engineSize,
      String typeFuel,
      String Transmissiion,
      String Drivetrain,
      int Door,
      int seats,
      XFile video,
      String status,
      double lat,
      double lon,
      String color) async {
    var result = await data.AddCars(
        brand,
        year,
        model,
        price,
        milleage,
        engineSize,
        typeFuel,
        Transmissiion,
        Drivetrain,
        Door,
        seats,
        video,
        status,
        lat,
        lon,
        color);
    result.fold(
      (error) {
        emit(state.copyWith(error: error.message));
        print(error.message);
      },
      (data) {
        emit(state.copyWith(isSuccessAddCar: true));
      },
    );
  }

  void getDataProfile() async {
    var result = await data.getDataStoreProfile();
    result.fold((error) {}, (data) {
      emit(state.copyWith(dataStore: data));
    });
  }

  void EditDataProfile(
    String name,
    String description,
    String phone,
    String closeTime,
    String OpenTime,
    String lat,
    String lot,
    List<String> day,
  ) async {
    var result = await data.editDataProfile(
      name,
      description,
      phone,
      closeTime,
      OpenTime,
      lat,
      lot,
      day,
    );
    result.fold(
      (e) {
        emit(state.copyWith(error: e.message));
      },
      (data) {
        emit(state.copyWith(isSuccess: true)); //تعديييييييييييييل
      },
    );
  }
}
