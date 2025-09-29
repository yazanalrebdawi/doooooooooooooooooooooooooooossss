import 'dart:io';

import 'package:dooss_business_app/core/app/manager/app_manager_cubit.dart';
import 'package:dooss_business_app/core/app/manager/app_manager_state.dart';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/network/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShowPhotoUserWidget extends StatelessWidget {
  const ShowPhotoUserWidget({
    super.key,
    this.trailing,
    required this.isShowedit,
    this.localImage, 
  });

  final Widget? trailing;
  final bool isShowedit;
  final File? localImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (localImage != null) 
          CircleAvatar(
            radius: 50.r,
            backgroundColor: Colors.grey[200],
            backgroundImage: FileImage(localImage!),
          )
        else
          BlocSelector<AppManagerCubit, AppManagerState, String?>(
            selector: (state) => state.user?.avatar?.path,
            builder: (context, avatarPath) {
              if (avatarPath == null) {
                return CircleAvatar(
                  radius: 50.r,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 95.sp,
                  ),
                );
              }

              final String fullUrl = ApiUrls.media(avatarPath);
              return CircleAvatar(
                radius: 50.r,
                backgroundColor: Colors.grey[200],
                backgroundImage: CachedNetworkImageProvider(fullUrl),
              );
            },
          ),
        if (isShowedit)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderBrand, width: 2.w),
              ),
              child: trailing,
            ),
          ),
      ],
    );
  }
}
