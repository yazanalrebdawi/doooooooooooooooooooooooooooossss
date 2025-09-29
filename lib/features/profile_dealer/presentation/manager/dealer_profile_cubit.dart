import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/data_source/dealer_profile_remote_data_source.dart';
import 'dealer_profile_state.dart';

class DealerProfileCubit extends Cubit<DealerProfileState> {
  final DealerProfileRemoteDataSource _dataSource;

  DealerProfileCubit(this._dataSource) : super(const DealerProfileState());

  void loadDealerProfile(String dealerId) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    final result = await _dataSource.fetchDealerProfile(dealerId);
    
    result.fold(
      (failure) {
        // معالجة خاصة لخطأ الـ authentication
        if (failure.message.contains('401') || failure.message.contains('Authentication')) {
          emit(state.copyWith(
            isLoading: false,
            error: 'يرجى تسجيل الدخول مرة أخرى',
          ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            error: failure.message,
          ));
        }
      },
      (dealer) {
        emit(state.copyWith(
          isLoading: false,
          dealer: dealer,
        ));
      },
    );
  }

  void loadReels(String dealerId) async {
    emit(state.copyWith(isLoadingReels: true));
    
    final result = await _dataSource.fetchReels(dealerId);
    
    result.fold(
      (failure) {
        // معالجة خاصة لخطأ الـ authentication
        if (failure.message.contains('401') || failure.message.contains('Authentication')) {
          emit(state.copyWith(
            isLoadingReels: false,
            error: 'يرجى تسجيل الدخول مرة أخرى',
          ));
        } else {
          emit(state.copyWith(
            isLoadingReels: false,
            error: failure.message,
          ));
        }
      },
      (reels) {
        emit(state.copyWith(
          isLoadingReels: false,
          reels: reels,
        ));
      },
    );
  }

  void loadCars(String dealerId) async {
    emit(state.copyWith(isLoadingCars: true));
    
    final result = await _dataSource.fetchCars(dealerId);
    
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingCars: false,
          error: failure.message,
        ));
      },
      (cars) {
        emit(state.copyWith(
          isLoadingCars: false,
          cars: cars,
        ));
      },
    );
  }

  void loadServices(String dealerId) async {
    emit(state.copyWith(isLoadingServices: true));
    
    final result = await _dataSource.fetchServices(dealerId);
    
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingServices: false,
          error: failure.message,
        ));
      },
      (services) {
        emit(state.copyWith(
          isLoadingServices: false,
          services: services,
        ));
      },
    );
  }

  void toggleFollow() async {
    if (state.dealer == null) return;
    
    final result = await _dataSource.toggleFollow(state.dealer!.id);
    
    result.fold(
      (failure) {
        emit(state.copyWith(error: failure.message));
      },
      (isFollowing) {
        final updatedDealer = state.dealer!.copyWith(isFollowing: isFollowing);
        emit(state.copyWith(dealer: updatedDealer));
      },
    );
  }
}
