import 'dart:io';

abstract class ImageServices {
  Future<void> saveProfileImageService(File image);
  Future<File?> getProfileImageService();
  Future<void> removeProfileImageService();
}
