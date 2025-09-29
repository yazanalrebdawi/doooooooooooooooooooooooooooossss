import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_cubit.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_state.dart';
import 'package:dooss_business_app/features/my_profile/presentation/pages/saved_items_screen.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/card_settings_widget.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/settings_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivitySettingsWidget extends StatefulWidget {
  const ActivitySettingsWidget({super.key});

  @override
  State<ActivitySettingsWidget> createState() => _ActivitySettingsWidgetState();
}

class _ActivitySettingsWidgetState extends State<ActivitySettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return CardSettingsWidget(
      text: "My Activity",
      height: 114,
      widget: SettingsRowWidget(
        iconBackgroundColor: Color(0xffFCE7F3),
        iconColor: Color(0xffDB2777),
        iconData: Icons.favorite,
        text: "Saved Listings",
        trailing: Row(
          children: [
            BlocSelector<MyProfileCubit, MyProfileState, int>(
              selector: (state) {
                return state.numberOfList;
              },
              builder: (context, state) {
                return CircleAvatar(
                  radius: 13.r,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    state.toString(),
                    style: AppTextStyles.s12w400.copyWith(
                      fontFamily: AppTextStyles.fontPoppins,
                      color: AppColors.borderBrand,
                    ),
                  ),
                );
              },
            ),
            Icon(Icons.arrow_forward_ios, size: 16.r, color: Color(0xff9CA3AF)),
          ],
        ),
        onTap: () {
          // context.push(RouteNames.savedItemsScreen);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider.value(
                    value: BlocProvider.of<MyProfileCubit>(context),
                    child: SavedItemsScreen(),
                  ),
            ),
          );
        },
      ),
    );
  }
}
