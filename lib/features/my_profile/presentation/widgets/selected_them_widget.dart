import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/app/manager/app_manager_state.dart';
import 'package:dooss_business_app/core/models/enums/app_them_enum.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/dark_theme_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/light_theme_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedThemWidget extends StatelessWidget {
  const SelectedThemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppManagerCubit, AppManagerState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isLight = state.themeMode == AppThemeEnum.light;

        return Column(
          spacing: 10.h,
          children: [
            LightThemeWidget(
              isSelected: isLight,
              onTap: () {
                if (!isLight) {
                  context.read<AppManagerCubit>().toggleTheme();
                }
              },
            ),
            DarkThemeWidget(
              isSelected: !isLight,
              onTap: () {
                if (isLight) {
                  context.read<AppManagerCubit>().toggleTheme();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
