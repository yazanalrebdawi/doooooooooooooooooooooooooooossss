import 'package:dooss_business_app/user/features/home/data/data_source/reel_remote_data_source.dart';
import 'package:dooss_business_app/user/features/home/presentaion/manager/like/like_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikeCubit extends Cubit<LikeState> {
  final ReelRemoteDataSource dataSource;

  LikeCubit({required this.dataSource}) : super(LikeState());

  /// الإعجاب أو إزالة الإعجاب على ريل معيّن
  void likeReel(int reelId) async {
    print('❤️ ReelCubit: Trying to like reel with ID: $reelId');

    final result = await dataSource.likeReel(reelId);

    result.fold(
      (failure) {
        print('❌ ReelCubit: Error liking reel: ${failure.message}');
      },
      (_) {
        print('✅ ReelCubit: Successfully liked/unliked reel $reelId');

        // ✅ تعديل حالة الريل داخل الليست (مثلاً تبديل isLiked أو زيادة عدد اللايكات)
        final updatedReels = state.reels.map((reel) {
          if (reel.id == reelId) {
            return reel.copyWith(
              liked: !reel.liked,
              likesCount:
                  reel.liked ? (reel.likesCount - 1) : (reel.likesCount + 1),
            );
          }
          return reel;
        }).toList();

        emit(state.copyWith(reels: updatedReels, error: null));
      },
    );
  }
}
