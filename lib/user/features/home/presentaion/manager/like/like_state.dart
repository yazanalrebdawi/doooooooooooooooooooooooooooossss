import 'package:dooss_business_app/user/features/home/data/models/reel_model.dart';

class LikeState {
  final List<ReelModel> reels; // قائمة الريلز
  final bool isLoading; // حالة التحميل
  final String? error; // الخطأ إذا وجد

  const LikeState({
    this.reels = const [],
    this.isLoading = false,
    this.error,
  });

  // نسخة جديدة من الستيت مع تعديل مطلوب فقط
  LikeState copyWith({
    List<ReelModel>? reels,
    bool? isLoading,
    String? error,
  }) {
    return LikeState(
      reels: reels ?? this.reels,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
