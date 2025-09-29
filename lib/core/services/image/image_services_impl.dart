import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dooss_business_app/core/constants/cache_keys.dart';
import 'package:dooss_business_app/core/services/image/image_services.dart';
import 'package:dooss_business_app/core/services/storage/shared_preferances/shared_preferences_service.dart';

class ImageServicesImpl implements ImageServices {
  final SharedPreferencesService storagePreferences;

  ImageServicesImpl({required this.storagePreferences});

  //?-------------------------------------------------------------
  //* Save
  @override
  Future<void> saveProfileImageService(File image) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = image.path.split('/').last;
      final savedImage = await image.copy('${appDir.path}/$fileName');
      await storagePreferences.saveProfileImageInCache(
        CacheKeys.imageProfile,
        savedImage.path,
      );
    } catch (e) {
      log('Error saving profile image: $e');
    }
  }

  //?-------------------------------------------------------------
  //* Get
  @override
  Future<File?> getProfileImageService() async {
    try {
      final path = await storagePreferences.getProfileImageInCache();
      if (path != null) return File(path);
    } catch (e) {
      log('Error getting profile image: $e');
    }
    return null;
  }

  //?-------------------------------------------------------------
  //* Remove
  @override
  Future<void> removeProfileImageService() async {
    try {
      final path = await storagePreferences.getProfileImageInCache();
      if (path != null) {
        final file = File(path);
        if (await file.exists()) await file.delete();
      }

      await storagePreferences.removeProfileImageInCache();
    } catch (e) {
      log('Error removing profile image: $e');
    }
  }

  //?-------------------------------------------------------------
}
