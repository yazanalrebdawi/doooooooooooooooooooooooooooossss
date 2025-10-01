import 'package:dooss_business_app/user/core/cubits/optimized_cubit.dart';
import 'home_state.dart';

class HomeCubit extends OptimizedCubit<HomeState> {
  HomeCubit() : super(const HomeState());

  /// تحديث الفهرس الحالي للشاشة
  void updateCurrentIndex(int index) {
    emitOptimized(state.copyWith(currentIndex: index));
  }

  /// تحديث نوع التصفح المحدد
  void updateSelectedBrowseType(int type) {
    emitOptimized(state.copyWith(selectedBrowseType: type));
  }

  /// تعيين حالة التحميل
  void setLoading(bool loading) {
    safeEmit(state.copyWith(isLoading: loading));
  }
}
