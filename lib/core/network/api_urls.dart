class ApiUrls {
  ApiUrls._();

  // 🟢 Base URLs
  static const String _baseURl = 'http://192.168.1.129:8010/api';
  static const String _baseMediaUrl =
      'http://192.168.1.104:8010'; // للصور والفيديو
  static String media(String path) => '$_baseMediaUrl$path'; // Getter للصور

  // 🟢 Auth
  static const String rigester = '$_baseURl/users/register/';
  static const String login = '$_baseURl/users/login/';
  static const String logout = '$_baseURl/users/logout/';
  static const String profile = '$_baseURl/users/profile/';
  static const String requestOtp = '$_baseURl/users/request-otp/';
  static const String refreshToken = '$_baseURl/users/refresh/';
  static const String verifyOtp = '$_baseURl/users/verify/';
  static const String verifyForgetPasswordOtp =
      '$_baseURl/users/reset-password/';
  static const String resendOtp = '$_baseURl/users/request-otp/';
  static const String forgetPassword = '$_baseURl/users/forgot-password/';
  static const String resetPassword = '$_baseURl/users/reset-password/';
  static const String setNewPassword = '$_baseURl/users/set-new-password/';
  static const String changePassword = '$_baseURl/users/change-password/';
  static const String updateProfile = '$_baseURl/users/update-profile/';
  static const String updatePassword = '$_baseURl/users/update-password/';

  // 🟢 Home
  static const String statuseWork = '$_baseURl/';
  static const String homeData = '$_baseURl/';

  // 🟢 Cars
  static const String cars = '$_baseURl/cars/';

  // 🟢 Products
  static const String products = '$_baseURl/products/';

  // 🟢 Services
  static const String servicesNearby = '$_baseURl/nearby/';
  static const String serviceDetails = '$_baseURl/services/';

  // 🟢 Reels
  static const String reels = '$_baseURl/reels/public/';

  // 🟢 Dealers
  static const String dealerProfile = '$_baseURl/dealers/';
  static const String dealerProfileWithId = '$_baseURl/dealers/{id}/profile/';
  static const String dealerReels = '$_baseURl/dealers/{id}/reels/';
  static const String dealerCars = '$_baseURl/dealers/{id}/cars/';
  static const String dealerServices = '$_baseURl/dealers/{id}/services/';
  static const String dealerFollow = '$_baseURl/dealers/{id}/follow/';

  // 🟢 Categories & Branches
  static const String categories = '$_baseURl/';
  static const String branches = '$_baseURl/';

  // 🟢 Edit Profile
  static const String getInfoProfile = '$_baseURl/users/profile/';
  static const String editInfoProfile = '$_baseURl/users/profile/update/';
  static const String changePasswordInProfile =
      '$_baseURl/users/set-new-password/';

  // 🟢 Favorites
  static const String getFavorites = '$_baseURl/favorites/';
  static const String removeItemOfFavorites = '$_baseURl/favorites/';

  // 🟢 Change Phone Number
  static const String cancelUpdatePhoneOtp =
      '$_baseURl/users/profile/phone/cancel/';
  static const String confirmUpdatePhone =
      '$_baseURl/users/profile/phone/confirm/';

  // 🟢 Chat
  static const String chats = '$_baseURl/chats/';
  static const String wsBaseUrl = 'ws://192.168.1.219:8020';
}
