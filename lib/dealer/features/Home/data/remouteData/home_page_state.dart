import 'package:dooss_business_app/dealer/features/Home/data/models/dashboard_info_model.dart';
import 'package:dooss_business_app/dealer/features/Home/data/models/data_profile_models.dart';
import 'package:dooss_business_app/dealer/features/Home/data/models/product_data_model.dart';
import 'package:dooss_business_app/user/core/utils/response_status_enum.dart';

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
  final ResponseStatusEnum deleateAccount;
  final String? errorDeleteAccount;

  HomepageState({
    required this.allProduct,
    this.errorDeleteAccount,
    this.error,
    this.deleateAccount = ResponseStatusEnum.initial,
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
      String? errorDeleteAccount,
      String? error,
      ResponseStatusEnum? deleateAccount,
      DealerDashboardInfo? dataDash,
      bool? isSuccessAddCar,
      bool? isLoadingFecthProductData,
      bool? isSuccessEditProduct,
      DataProfileModel? dataStore,
      bool? isSuccessGetProduct,
      bool? isLoadingGetProduct,
      bool? isLoadingeditProfile,
      bool? isSuccess}) {
    return HomepageState(
        allProduct: allProduct ?? this.allProduct,
        deleateAccount: deleateAccount ?? this.deleateAccount,
        error: error,
        errorDeleteAccount: errorDeleteAccount,
        dataDash: dataDash ?? this.dataDash,
        isSuccessAddCar: isSuccessAddCar ?? false,
        isLoadingFecthProductData: isLoadingFecthProductData ?? false,
        isSuccessEditProduct: isSuccessEditProduct ?? false,
        dataStore: dataStore ?? this.dataStore,
        isSuccessGetProduct: isSuccessGetProduct ?? false,
        isLoadingGetProduct: isLoadingGetProduct ?? false,
        isLoadingeditProfile: isLoadingeditProfile ?? false,
        isSuccess: isSuccess ?? false);
  }
}
