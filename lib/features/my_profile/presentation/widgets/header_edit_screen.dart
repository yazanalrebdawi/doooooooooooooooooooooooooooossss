import 'dart:developer';
import 'dart:io';
import 'package:dooss_business_app/core/constants/colors.dart';
import 'package:dooss_business_app/core/constants/text_styles.dart';
import 'package:dooss_business_app/core/localization/app_localizations.dart';
import 'package:dooss_business_app/features/my_profile/presentation/manager/my_profile_cubit.dart';
import 'package:dooss_business_app/features/my_profile/presentation/widgets/show_photo_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class HeaderEditScreen extends StatefulWidget {
  const HeaderEditScreen({super.key});

  @override
  State<HeaderEditScreen> createState() => _HeaderEditScreenState();
}

class _HeaderEditScreenState extends State<HeaderEditScreen> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShowPhotoUserWidget(
              isShowedit: true,
              localImage: _selectedImage,
              trailing: IconButton(
                padding: EdgeInsets.zero,
                onPressed: _pickImage,
                icon: Icon(Icons.edit, color: AppColors.buttonText, size: 16.r),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              AppLocalizations.of(
                    context,
                  )?.translate("Click to change your profile picture") ??
                  "Click to change your profile picture",
              style: AppTextStyles.s14w400.copyWith(color: Color(0xff4B5563)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final compressedFile = await _compressImage(file);

      setState(() {
        _selectedImage = compressedFile;
      });

      final cubit = context.read<MyProfileCubit>();
      await cubit.updateAvatar(compressedFile);
      log('✅ Avatar upload requested');
    }
  }

  Future<File> _compressImage(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes)!;
    final resized = img.copyResize(image, width: 600);

    final dir = await getTemporaryDirectory();
    final target = File(
      '${dir.path}/avatar_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await target.writeAsBytes(img.encodeJpg(resized, quality: 85));

    return target;
  }
}
