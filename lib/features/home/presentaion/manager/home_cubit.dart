import 'package:dooss_business_app/core/cubits/optimized_cubit.dart';
import 'home_state.dart';

// Cubit
class HomeCubit extends OptimizedCubit<HomeState> {
  HomeCubit() : super(const HomeState());

  //! Done
  void updateCurrentIndex(int index) {
    emitOptimized(state.copyWith(currentIndex: index));
  }
  
  //! Done
  void updateSelectedBrowseType(int type) {
    emitOptimized(state.copyWith(selectedBrowseType: type));
  }

  void setLoading(bool loading) {
    safeEmit(state.copyWith(isLoading: loading));
  }
}
