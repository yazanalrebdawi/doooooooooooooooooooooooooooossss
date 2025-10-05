import 'package:dooss_business_app/dealer/features/Home/data/models/dashboard_info_model.dart';
import 'package:dooss_business_app/dealer/features/Home/data/models/data_profile_models.dart';
import 'package:dooss_business_app/dealer/features/Home/data/models/product_data_model.dart';

class HomepageState {
  final List<productdata> allProduct;
  final String? error;
  final DealerDashboardInfo dataDash;
  final bool isSuccessAddCar;
  final bool isLoadingFecthProductData;
  final bool isSuccessEditProduct;
  final DataProfileModel dataStore;
  final bool isSuccessGetProduct;
  final bool isLoadingGetProduct;
  final bool isLoadingeditProfile;
  final bool isSuccess;
  HomepageState(
      {required this.allProduct,
      this.error,
      required this.dataDash,
      required this.isSuccessAddCar,
      this.isLoadingFecthProductData = false,
      this.isSuccessEditProduct = false,
      required this.dataStore,
      this.isSuccessGetProduct = false,
      this.isLoadingGetProduct = false,
      this.isLoadingeditProfile = false,
      this.isSuccess = false,
      });

  HomepageState copyWith(
      {List<productdata>? allProduct,
      String? error,
      DealerDashboardInfo? dataDash,
      bool? isSuccessAddCar,
      bool? isLoadingFecthProductData,
      bool? isSuccessEditProduct,
      DataProfileModel? dataStore,
      bool? isSuccessGetProduct,
      bool? isLoadingGetProduct,
      bool? isLoadingeditProfile,
      bool? isSuccess
      }) {
    return HomepageState(
        allProduct: allProduct ?? this.allProduct,
        error: error,
        dataDash: dataDash ?? this.dataDash,
        isSuccessAddCar: isSuccessAddCar ?? false,
        isLoadingFecthProductData: isLoadingFecthProductData ?? false,
        isSuccessEditProduct: isSuccessEditProduct ?? false,
        dataStore: dataStore ?? this.dataStore,
        isSuccessGetProduct: isSuccessGetProduct ?? false,
        isLoadingGetProduct: isLoadingGetProduct ?? false,
        isLoadingeditProfile:  isLoadingeditProfile ?? false,
        isSuccess: isSuccess ?? false
        );
  }
}
