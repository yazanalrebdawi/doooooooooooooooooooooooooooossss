import 'dart:developer';

import 'package:dooss_business_app/user/core/cubits/optimized_cubit.dart';
import '../../data/data_source/reel_remote_data_source.dart';
import 'reel_state.dart';

class ReelCubit extends OptimizedCubit<ReelState> {
  final ReelRemoteDataSource dataSource;

  ReelCubit({required this.dataSource}) : super(ReelState.initial());

  /// تحميل الريلز (صفحة أولى أو أي صفحة محددة)
  void loadReels({int page = 1, int pageSize = 20}) async {
    safeEmit(state.copyWith(isLoading: true, error: null));

    final result = await dataSource.fetchReels(
      page: page,
      pageSize: pageSize,
      ordering: '-created_at',
    );

    result.fold(
      (failure) {
        print('❌ ReelCubit: Error loading reels: ${failure.message}');
        safeEmit(state.copyWith(error: failure.message, isLoading: false));
      },
      (reelsResponse) {
        print(
          '✅ ReelCubit: Successfully loaded ${reelsResponse.results.length} reels',
        );

        final updatedReels =
            page == 1
                ? reelsResponse.results
                : [...state.reels, ...reelsResponse.results];

        safeEmit(
          state.copyWith(
            reels: updatedReels,
            isLoading: false,
            hasNextPage: reelsResponse.next != null,
            currentPage: page,
            totalCount: reelsResponse.count,
          ),
        );
      },
    );
  }

  /// تحميل المزيد من الريلز عند التمرير
  void loadMoreReels() async {
    if (state.isLoading || !state.hasNextPage) return;

    final nextPage = state.currentPage + 1;
    print('🔄 ReelCubit: Loading more reels (page: $nextPage)...');

    final result = await dataSource.fetchReels(
      page: nextPage,
      pageSize: 20,
      ordering: '-created_at',
    );

    result.fold(
      (failure) {
        print('❌ ReelCubit: Error loading more reels: ${failure.message}');
        safeEmit(state.copyWith(error: failure.message));
      },
      (reelsResponse) {
        print(
          '✅ ReelCubit: Successfully loaded ${reelsResponse.results.length} more reels',
        );

        safeEmit(
          state.copyWith(
            reels: [...state.reels, ...reelsResponse.results],
            hasNextPage: reelsResponse.next != null,
            currentPage: nextPage,
            error: null,
          ),
        );
      },
    );
  }

  /// تحديث الريلز عند السحب للتحديث
  void refreshReels() async {
    print('🔄 ReelCubit: Refreshing reels...');
    loadReels(page: 1, pageSize: 20);
  }

  /// تغيير مؤشر الريل الحالي
  void changeReelIndex(int newIndex) {
    if (newIndex >= 0 && newIndex < state.reels.length) {
      safeEmit(state.copyWith(currentReelIndex: newIndex));
      print('🔄 ReelCubit: Reel index changed to $newIndex');
    }
  }

  /// الانتقال مباشرة إلى ريل محدد بواسطة ID
  void jumpToReelById(int reelId) {
    final reelIndex = state.reels.indexWhere((reel) => reel.id == reelId);
    if (reelIndex != -1) {
      changeReelIndex(reelIndex);
      print('🎯 ReelCubit: Jumped to reel with ID $reelId at index $reelIndex');
    }
  }

  /// مسح أي خطأ موجود
  void clearError() {
    safeEmit(state.copyWith(error: null));
  }

  /// إعادة حالة الريل للوضع الابتدائي
  void resetState() {
    emit(ReelState.initial());
  }
}
