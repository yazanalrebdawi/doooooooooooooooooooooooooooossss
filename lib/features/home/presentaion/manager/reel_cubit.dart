<<<<<<< HEAD
import 'package:dooss_business_app/core/cubits/optimized_cubit.dart';
import '../../data/data_source/reel_remote_data_source.dart';
import '../../data/models/reel_model.dart';
=======
import 'dart:developer';

import 'package:dooss_business_app/core/cubits/optimized_cubit.dart';
import '../../data/data_source/reel_remote_data_source.dart';
>>>>>>> zoz
import 'reel_state.dart';

class ReelCubit extends OptimizedCubit<ReelState> {
  final ReelRemoteDataSource dataSource;

  ReelCubit({required this.dataSource}) : super(ReelState.initial());

  void loadReels({int page = 1, int pageSize = 20}) async {
    safeEmit(state.copyWith(isLoading: true, error: null));
<<<<<<< HEAD
    
=======

>>>>>>> zoz
    final result = await dataSource.fetchReels(
      page: page,
      pageSize: pageSize,
      ordering: '-created_at',
    );

    result.fold(
      (failure) {
        print('❌ ReelCubit: Error loading reels: ${failure.message}');
<<<<<<< HEAD
        safeEmit(state.copyWith(
          error: failure.message,
          isLoading: false,
        ));
      },
      (reelsResponse) {
        print('✅ ReelCubit: Successfully loaded ${reelsResponse.results.length} reels');
        
        // If it's the first page, replace the list, otherwise append
        final updatedReels = page == 1 
            ? reelsResponse.results 
            : [...state.reels, ...reelsResponse.results];
        
        safeEmit(state.copyWith(
          reels: updatedReels,
          isLoading: false,
          hasNextPage: reelsResponse.next != null,
          currentPage: page,
          totalCount: reelsResponse.count,
        ));
=======
        safeEmit(state.copyWith(error: failure.message, isLoading: false));
      },
      (reelsResponse) {
        print(
          '✅ ReelCubit: Successfully loaded ${reelsResponse.results.length} reels',
        );

        // If it's the first page, replace the list, otherwise append
        final updatedReels =
            page == 1
                ? reelsResponse.results
                : [...state.reels, ...reelsResponse.results];
        log("😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂");
        safeEmit(
          state.copyWith(
            reels: updatedReels,
            isLoading: false,
            hasNextPage: reelsResponse.next != null,
            currentPage: page,
            totalCount: reelsResponse.count,
          ),
        );
>>>>>>> zoz
      },
    );
  }

  void loadMoreReels() async {
    if (state.isLoading || !state.hasNextPage) return;
<<<<<<< HEAD
    
    final nextPage = state.currentPage + 1;
    print('🔄 ReelCubit: Loading more reels (page: $nextPage)...');
    
=======

    final nextPage = state.currentPage + 1;
    print('🔄 ReelCubit: Loading more reels (page: $nextPage)...');

>>>>>>> zoz
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
<<<<<<< HEAD
        print('✅ ReelCubit: Successfully loaded ${reelsResponse.results.length} more reels');
        
        safeEmit(state.copyWith(
          reels: [...state.reels, ...reelsResponse.results],
          hasNextPage: reelsResponse.next != null,
          currentPage: nextPage,
          error: null,
        ));
=======
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
>>>>>>> zoz
      },
    );
  }

  void refreshReels() async {
    print('🔄 ReelCubit: Refreshing reels...');
    loadReels(page: 1, pageSize: 20);
  }

  void changeReelIndex(int newIndex) {
    if (newIndex >= 0 && newIndex < state.reels.length) {
      safeEmit(state.copyWith(currentReelIndex: newIndex));
      print('🔄 ReelCubit: Reel index changed to $newIndex');
    }
  }

  void jumpToReelById(int reelId) {
    final reelIndex = state.reels.indexWhere((reel) => reel.id == reelId);
    if (reelIndex != -1) {
      changeReelIndex(reelIndex);
      print('🎯 ReelCubit: Jumped to reel with ID $reelId at index $reelIndex');
    }
  }

  void clearError() {
<<<<<<< HEAD
          safeEmit(state.copyWith(error: null));
=======
    safeEmit(state.copyWith(error: null));
>>>>>>> zoz
  }

  void resetState() {
    emit(ReelState.initial());
  }
}
