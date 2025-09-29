import 'dart:developer';
import 'dart:io';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:dooss_business_app/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/core/utils/response_status_enum.dart';
import 'package:dooss_business_app/features/my_profile/data/models/favorite_model.dart';
import 'package:dooss_business_app/features/my_profile/data/source/repo/my_profile_repository.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  MyProfileCubit({required this.repository})
    : super(MyProfileState(numberOfList: 0));

  final MyProfileRepository repository;

  //?---------------------------------------------------------------------
  //* Change Password
  Future<void> changePassword(String newPassword, String phone) async {
    emit(state.copyWith(statusChangePassword: ResponseStatusEnum.loading));

    final result = await repository.changePasswordRepo(newPassword, phone);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            statusChangePassword: ResponseStatusEnum.failure,
            errorChangePassword: failure.message,
          ),
        );
      },
      (success) {
        emit(state.copyWith(statusChangePassword: ResponseStatusEnum.success));
      },
    );
  }
  //?---------------------------------------------------------------------

  Future<void> updateAvatar(File avatar) async {
    emit(state.copyWith(statusEdit: ResponseStatusEnum.loading));

    try {
      final result = await repository.updateAvatarRepo(avatar);

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              statusEdit: ResponseStatusEnum.failure,
              errorEditInfo: failure.message,
            ),
          );
        },
        (editUser) {
          emit(
            state.copyWith(
              statusEdit: ResponseStatusEnum.success,
              editUser: editUser,
              //! تحديت بكيبوت
              // إذا تحب، يمكنك تحديث user أيضاً
              // user: editUser.toUserModel(),
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          statusEdit: ResponseStatusEnum.failure,
          errorEditInfo: e.toString(),
        ),
      );
    }
  }
  //?---------------------------------------------------------------------

  //* 🟢 Get User Info
  Future<void> getInfoUser() async {
    emit(state.copyWith(statusInfoUser: ResponseStatusEnum.loading));

    final result = await repository.getInfoUserRepo();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            statusInfoUser: ResponseStatusEnum.failure,
            errorEditInfo: failure.message,
          ),
        );
      },
      (user) {
        appLocator<SecureStorageService>().updateUserModel(newUser: user);
        emit(
          state.copyWith(
            statusInfoUser: ResponseStatusEnum.success,
            user: user,
          ),
        );
      },
    );
  }

  //?---------------------------------------------------------------------
  Future<void> updateProfile({
    String? name,
    String? phone,
    File? avatar,
  }) async {
    emit(state.copyWith(statusEdit: ResponseStatusEnum.loading));

    final result = await repository.updateProfileRepo(name, phone, avatar);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            statusEdit: ResponseStatusEnum.failure,
            errorEditInfo: failure.message,
          ),
        );
      },
      (editUser) {
        emit(
          state.copyWith(
            statusEdit: ResponseStatusEnum.success,
            editUser: editUser,
          ),
        );
      },
    );
  }

  //?---------------------------------------------------------------------
  //* Request OTP
  Future<void> requestOtp({required String phone}) async {
    emit(state.copyWith(statusRequestOtp: ResponseStatusEnum.loading));

    final result = await repository.requestOtpRepo(phone: phone);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            statusRequestOtp: ResponseStatusEnum.failure,
            errorRequestOtp: failure.message,
          ),
        );
      },
      (message) {
        emit(state.copyWith(statusRequestOtp: ResponseStatusEnum.success));
      },
    );
  }

  //?---------------------------------------------------------------------

  //* Cancel Phone Update
  Future<void> cancelPhoneUpdate() async {
    emit(state.copyWith(statusCancelPhone: ResponseStatusEnum.loading));

    final result = await repository.cancelPhoneUpdateRepo();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            statusCancelPhone: ResponseStatusEnum.failure,
            errorCancelPhone: failure.message,
          ),
        );
      },
      (message) {
        emit(state.copyWith(statusCancelPhone: ResponseStatusEnum.success));
      },
    );
  }

  //?---------------------------------------------------------------------
  //* Confirm Phone
  Future<void> confirmPhone({
    required String phone,
    required String code,
  }) async {
    emit(state.copyWith(statusConfirmPhone: ResponseStatusEnum.loading));

    final result = await repository.confirmPhoneRepo(phone: phone, code: code);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            statusConfirmPhone: ResponseStatusEnum.failure,
            errorConfirmPhone: failure.message,
          ),
        );
      },
      (message) {
        emit(state.copyWith(statusConfirmPhone: ResponseStatusEnum.success));
      },
    );
  }

  //?---------------------------------------------------------------------

  void showCars() {
    final cars = filterCarsFavorites();
    emit(state.copyWith(lsitFilterations: cars));
  }

  List<FavoriteModel> filterCarsFavorites() {
    final favorites = state.listFavorites ?? [];
    if (favorites.isEmpty) return [];

    return favorites
        .where((fav) => fav.targetType.toLowerCase() == 'car')
        .toList();
  }
  //?---------------------------------------------------------

  void showAccessories() {
    final accessories = filterAccessoriesFavorites();
    emit(state.copyWith(lsitFilterations: accessories));
  }

  List<FavoriteModel> filterAccessoriesFavorites() {
    final favorites = state.listFavorites ?? [];
    if (favorites.isEmpty) return [];

    return favorites
        .where((fav) => fav.targetType.toLowerCase() == 'product')
        .toList();
  }
  //?---------------------------------------------------------

  void showRecent() {
    final recent = filterRecentFavorites();
    emit(state.copyWith(lsitFilterations: recent));
  }

  List<FavoriteModel> filterRecentFavorites() {
    final favorites = state.listFavorites ?? [];
    if (favorites.isEmpty) return [];

    final recent = List<FavoriteModel>.from(favorites)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return recent;
  }
  //?---------------------------------------------------------

  //* Get Favorites
  Future<void> getFavorites() async {
    emit(state.copyWith(statusGetListFavorites: ResponseStatusEnum.loading));

    try {
      final result = await repository.getFavoriteRepo();
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              statusGetListFavorites: ResponseStatusEnum.failure,
              errorGetListFavorites: failure.message,
            ),
          );
        },
        (favorites) {
          final int numberItems = favorites.length;
          if (favorites.isEmpty) {
            log("");
            emit(
              state.copyWith(
                statusGetListFavorites: ResponseStatusEnum.success,
                listFavorites: [],
                numberOfList: 0,
              ),
            );
          } else {
            emit(
              state.copyWith(
                statusGetListFavorites: ResponseStatusEnum.success,
                listFavorites: favorites,
                numberOfList: numberItems,
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          statusGetListFavorites: ResponseStatusEnum.failure,
          errorGetListFavorites: e.toString(),
        ),
      );
    }
  }

  //?---------------------------------------------------------------------
  //* Delete Favorite
  Future<void> deleteFavorite(int favoriteId) async {
    emit(state.copyWith(statusDeleteFavorite: ResponseStatusEnum.loading));

    try {
      final result = await repository.deleteFavoriteRepo(favoriteId);

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              statusDeleteFavorite: ResponseStatusEnum.failure,
              errorDeleteFavorite: failure.message,
            ),
          );
        },
        (_) {
          final currentList = state.listFavorites ?? [];
          final updatedList =
              currentList.where((item) => item.id != favoriteId).toList();

          emit(
            state.copyWith(
              statusDeleteFavorite: ResponseStatusEnum.success,
              listFavorites: updatedList,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          statusDeleteFavorite: ResponseStatusEnum.failure,
          errorDeleteFavorite: e.toString(),
        ),
      );
    }
  }

 

  //?---------------------------------------------------------------------
}
