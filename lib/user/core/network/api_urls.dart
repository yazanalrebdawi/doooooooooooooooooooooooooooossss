class ApiUrls {
  ApiUrls._();

  // 🟢 Base URLs
  static const String baseURl = 'http://10.0.2.2:8010/api';
  static const String _baseMediaUrl =
      'http://192.168.1.103:8010'; // للصور والفيديو

  static String media(String path) => '$_baseMediaUrl$path'; // Getter للصور

  // 🟢 Auth
  static const String rigester = '$baseURl/users/register/';
  static const String login = '$baseURl/users/login/';
  static const String logout = '$baseURl/users/logout/';
  static const String profile = '$baseURl/users/profile/';
  static const String requestOtp = '$baseURl/users/request-otp/';
  static const String refreshToken = '$baseURl/users/refresh/';
  static const String verifyOtp = '$baseURl/users/verify/';
  static const String verifyForgetPasswordOtp =
      '$baseURl/users/reset-password/';
  static const String resendOtp = '$baseURl/users/request-otp/';
  static const String forgetPassword = '$baseURl/users/forgot-password/';
  static const String resetPassword = '$baseURl/users/reset-password/';
  static const String setNewPassword = '$baseURl/users/set-new-password/';
  static const String changePassword = '$baseURl/users/change-password/';
  static const String updateProfile = '$baseURl/users/update-profile/';
  static const String updatePassword = '$baseURl/users/update-password/';

  // 🟢 Home
  static const String statuseWork = '$baseURl/';
  static const String homeData = '$baseURl/';

  // 🟢 Cars
  static const String cars = '$baseURl/cars/';

  // 🟢 Products
  static const String products = '$baseURl/products/';

  // 🟢 Services
  static const String servicesNearby = '$baseURl/nearby/';
  static const String serviceDetails = '$baseURl/services/';

  // 🟢 Reels
  static const String reels = '$baseURl/reels/public/';

  // 🟢 Dealers
  static const String loginDaelar = '$baseURl/api/dealers/login/';
  static const String dealerProfile = '$baseURl/dealers/';
  static const String dealerProfileWithId = '$baseURl/dealers/{id}/profile/';
  static const String dealerReels = '$baseURl/dealers/{id}/reels/';
  static const String dealerCars = '$baseURl/dealers/{id}/cars/';
  static const String dealerServices = '$baseURl/dealers/{id}/services/';
  static const String dealerFollow = '$baseURl/dealers/{id}/follow/';

  // 🟢 Categories & Branches
  static const String categories = '$baseURl/';
  static const String branches = '$baseURl/';

  // 🟢 Edit Profile
  static const String getInfoProfile = '$baseURl/users/profile/';
  static const String editInfoProfile = '$baseURl/users/profile/update/';
  static const String changePasswordInProfile =
      '$baseURl/users/set-new-password/';

  // 🟢 Favorites
  static const String getFavorites = '$baseURl/favorites/';
  static const String removeItemOfFavorites = '$baseURl/favorites/';

  // 🟢 Change Phone Number
  static const String cancelUpdatePhoneOtp =
      '$baseURl/users/profile/phone/cancel/';
  static const String confirmUpdatePhone =
      '$baseURl/users/profile/phone/confirm/';

  // 🟢 Chat
  static const String chats = '$baseURl/chats/';
  static const String wsBaseUrl = 'ws://192.168.1.103:8020';
}
