import 'package:dooss_business_app/core/utils/response_status_enum.dart';
import 'package:dooss_business_app/features/auth/data/models/user_model.dart';
import 'package:dooss_business_app/features/my_profile/data/models/edit_user_model.dart';
import 'package:dooss_business_app/features/my_profile/data/models/favorite_model.dart';

class MyProfileState {
  //?----------------------------------------------------

  //* Edit Get
  final ResponseStatusEnum statusInfoUser;
  final UserModel? user;
  final EditUserModel? editUser;
  final String? errorEditInfo;

  final ResponseStatusEnum statusEdit;

  //?----------------------------------------------------

  final ResponseStatusEnum statusCancelPhone;
  final String? errorCancelPhone;

  //?----------------------------------------------------

  final ResponseStatusEnum statusConfirmPhone;
  final String? errorConfirmPhone;
  //?----------------------------------------------------
  final ResponseStatusEnum statusRequestOtp;
  final String? errorRequestOtp;

  //?----------------------------------------------------
  final ResponseStatusEnum statusChangePassword;
  final String? errorChangePassword;

  //?----------------------------------------------------
  final ResponseStatusEnum statusGetListFavorites;
  final String? errorGetListFavorites;
  final List<FavoriteModel>? listFavorites;
  final List<FavoriteModel>? lsitFilterations;
  final int numberOfList;

  //?----------------------------------------------------
  //* Delete Favorite
  final ResponseStatusEnum statusDeleteFavorite;
  final String? errorDeleteFavorite;

  //?----------------------------------------------------
  //* Constructor

  MyProfileState({
    this.lsitFilterations,
    required this.numberOfList,
    this.statusCancelPhone = ResponseStatusEnum.initial,
    this.errorCancelPhone,
    this.statusRequestOtp = ResponseStatusEnum.initial,
    this.errorRequestOtp,
    this.statusGetListFavorites = ResponseStatusEnum.initial,
    this.statusConfirmPhone = ResponseStatusEnum.initial,
    this.statusChangePassword = ResponseStatusEnum.initial,
    this.statusEdit = ResponseStatusEnum.initial,
    this.statusInfoUser = ResponseStatusEnum.initial,
    this.statusDeleteFavorite = ResponseStatusEnum.initial,
    this.listFavorites,
    this.errorConfirmPhone,
    this.user,
    this.errorGetListFavorites,
    this.editUser,
    this.errorEditInfo,
    this.errorChangePassword,
    this.errorDeleteFavorite,
  });

  //?-------------------------------------------------------------------------

  MyProfileState copyWith({
    List<FavoriteModel>? lsitFilterations,
    int? numberOfList,
    String? errorCancelPhone,
    ResponseStatusEnum? statusCancelPhone,
    ResponseStatusEnum? statusChangePassword,
    ResponseStatusEnum? statusConfirmPhone,
    ResponseStatusEnum? statusGetListFavorites,
    String? errorGetListFavorites,
    List<FavoriteModel>? listFavorites,
    String? errorRequestOtp,
    ResponseStatusEnum? statusRequestOtp,
    String? errorChangePassword,
    ResponseStatusEnum? statusEdit,
    EditUserModel? editUser,
    ResponseStatusEnum? statusInfoUser,
    UserModel? user,
    String? errorConfirmPhone,
    String? errorEditInfo,
    ResponseStatusEnum? statusDeleteFavorite,
    String? errorDeleteFavorite,
  }) {
    return MyProfileState(
      lsitFilterations: lsitFilterations ?? this.lsitFilterations,
      numberOfList: numberOfList ?? this.numberOfList,
      errorCancelPhone: errorCancelPhone,
      statusCancelPhone: statusCancelPhone ?? this.statusCancelPhone,
      statusRequestOtp: statusRequestOtp ?? this.statusRequestOtp,
      errorRequestOtp: errorRequestOtp,
      errorConfirmPhone: errorConfirmPhone,
      statusConfirmPhone: statusConfirmPhone ?? ResponseStatusEnum.initial,
      statusChangePassword: statusChangePassword ?? this.statusChangePassword,
      statusGetListFavorites:
          statusGetListFavorites ?? this.statusGetListFavorites,
      errorGetListFavorites: errorGetListFavorites,
      listFavorites: listFavorites ?? this.listFavorites,
      statusEdit: statusEdit ?? this.statusEdit,
      editUser: editUser ?? this.editUser,
      statusInfoUser: statusInfoUser ?? this.statusInfoUser,
      user: user ?? this.user,
      errorEditInfo: errorEditInfo,
      errorChangePassword: errorChangePassword,
      statusDeleteFavorite: statusDeleteFavorite ?? this.statusDeleteFavorite,
      errorDeleteFavorite: errorDeleteFavorite,
    );
  }
}
