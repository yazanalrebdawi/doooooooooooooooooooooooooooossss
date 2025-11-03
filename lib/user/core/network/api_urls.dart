class ApiUrls {
  ApiUrls._();

  // 🟢 Base URLs
  static const String baseURl = 'https://www.doossapp.com';
    static const String baseURlDealer = 'https://www.doossapp.com/api';
  static const String _baseMediaUrl = 'https://www.doossapp.com';
  // static const String baseURl = 'http://10.0.2.2:8010';
  static String media(String path) => '$_baseMediaUrl$path'; // Getter للصور

  // 🟢 Auth
  static const String rigester = '$baseURl/api/users/register/';
  static const String login = '$baseURl/api/users/login/';
  static const String logout = '$baseURl/api/users/logout/';
  static const String profile = '$baseURl/api/users/profile/';
  static const String requestOtp = '$baseURl/api/users/request-otp/';
  static const String refreshToken = '$baseURl/api/users/refresh/';
  static const String verifyOtp = '$baseURl/api/users/verify/';
  static const String verifyForgetPasswordOtp =
      '$baseURl/api/users/reset-password/';
  static const String resendOtp = '$baseURl/api/users/request-otp/';
  static const String forgetPassword = '$baseURl/api/users/forgot-password/';
  static const String resetPassword = '$baseURl/api/users/reset-password/';
  static const String setNewPassword = '$baseURl/api/users/set-new-password/';
  static const String changePassword = '$baseURl/api/users/change-password/';
  static const String updateProfile = '$baseURl/api/users/update-profile/';
  static const String updatePassword = '$baseURl/api/users/update-password/';
  static const String deleteUserAccount = '$baseURl/api/users/delete-account/';

  // 🟢 Home
  static const String statuseWork = '$baseURl/';
  static const String homeData = '$baseURl/';

  // 🟢 Cars
  static const String cars = '$baseURl/api/cars/';

  // 🟢 Products
  static const String products = '$baseURl/api/products/';

  // 🟢 Services
  static const String servicesNearby = '$baseURl/api/nearby/';
  static const String serviceDetails = '$baseURl/api/services/';

  // 🟢 Reels
  static const String reels = '$baseURl/api/reels/public/';

  // 🟢 Dealers
  static const String loginDaelar = '$baseURl/api/dealers/login/';
  static const String dealerProfile = '$baseURl/api/dealers/';
  static const String dealerProfileWithId =
      '$baseURl/api/dealers/{id}/profile/';
  static const String dealerReels = '$baseURl/api/dealers/{id}/reels/';
  static const String dealerCars = '$baseURl/api/dealers/{id}/cars/';
  static const String dealerServices = '$baseURl/api/dealers/{id}/services/';
  static const String dealerFollow = '$baseURl/api/dealers/{id}/follow/';
  static const String deleteDealerAccount =
      '$baseURl/api/users/dealers/delete-account/';

  // 🟢 Categories & Branches
  static const String categories = '$baseURl/';
  static const String branches = '$baseURl/';

  // 🟢 Edit Profile
  static const String getInfoProfile = '$baseURl/api/users/profile/';
  static const String editInfoProfile = '$baseURl/api/users/profile/update/';
  static const String changePasswordInProfile =
      '$baseURl/api/users/set-new-password/';

  // 🟢 Favorites
  static const String getFavorites = '$baseURl/api/favorites/';
  static const String removeItemOfFavorites = '$baseURl/api/favorites/';

  // 🟢 Change Phone Number
  static const String cancelUpdatePhoneOtp =
      '$baseURl/api/users/profile/phone/cancel/';
  static const String confirmUpdatePhone =
      '$baseURl/api/users/profile/phone/confirm/';

  // 🟢 Chat
  static const String chats = '$baseURl/api/chats/';
  // static const String wsBaseUrl = 'ws://192.168.1.103:8020';
}
