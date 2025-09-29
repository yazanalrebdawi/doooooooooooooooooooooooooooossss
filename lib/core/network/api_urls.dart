class ApiUrls {
  ApiUrls._();
  // static const String _baseURl = 'http://192.168.145.185:8010/api';
  // static const String _baseURl = 'http://192.168.1.22:8010/api';
  // IP الكمبيوتر على Wi-Fi

  //192.168.1.105
  static const String _baseURl = 'http://192.168.1.105:8010/api';
  static const String _baseMediaUrl =
      'http://192.168.1.105:8010'; //! للصور و الفيديو
  // 🟢 Getter عام للصور
  static String media(String path) => '$_baseMediaUrl$path';
  // POSTS
  static final String rigester = '$_baseURl/users/register/';
  static final String login = "$_baseURl/users/login/";
  static final String logout = "$_baseURl/users/logout/";

  static final String profile = "$_baseURl/users/profile/";
  static final String requestOtp = "$_baseURl/users/request-otp/";

  // Token refresh
  static final String refreshToken = "$_baseURl/users/refresh/";

  // Verify URLs
  static final String verifyOtp = "$_baseURl/users/verify/";
  static final String verifyForgetPasswordOtp =
      "$_baseURl/users/reset-password/";

  static final String resendOtp = "$_baseURl/users/request-otp/";
  static final String forgetPassword = "$_baseURl/users/forgot-password/";
  static final String resetPassword = "$_baseURl/users/reset-password/";
  static final String setNewPassword = "$_baseURl/users/set-new-password/";

  // Chat URLs
  static final String chats = "$_baseURl/chats/";
  static final String wsBaseUrl = "ws://192.168.1.219:8020";
  static final String changePassword = "$_baseURl/users/change-password/";
  static final String updateProfile = "$_baseURl/users/update-profile/";
  static final String updatePassword = "$_baseURl/users/update-password/";

  // Home
  static final String statuseWork = "$_baseURl/";
  static final String homeData = "$_baseURl/";

  //  cars
  static final String cars = "$_baseURl/cars/";

  //  products
  static final String products = "$_baseURl/products/";

  //  services
  static final String servicesNearby =
      "$_baseURl/nearby/"; // Using nearby endpoint for services

  static final String serviceDetails =
      "$_baseURl/services/"; // For individual service details

  //  reels
  static final String reels = "$_baseURl/reels/public/";

  //  dealer profile
  static final String dealerProfile =
      "$_baseURl/dealers/"; // Base URL for dealer endpoints
  static final String dealerProfileWithId = "$_baseURl/dealers/{id}/profile/";
  static final String dealerReels = "$_baseURl/dealers/{id}/reels/";
  static final String dealerCars = "$_baseURl/dealers/{id}/cars/";
  static final String dealerServices = "$_baseURl/dealers/{id}/services/";
  static final String dealerFollow = "$_baseURl/dealers/{id}/follow/";

  //  category
  static final String categories = "$_baseURl/";

  //  branches
  static final String branches = "$_baseURl/";

  //* Edit Profile
  static final String getInfoProfile = "$_baseURl/users/profile/";
  static final String editInfoProfile = "$_baseURl/users/profile/update/";
  static final String changePasswordInProfile =
      "$_baseURl/users/set-new-password/";

  //* Favorites
  static final String getFavorites = "$_baseURl/favorites/";
  static final String removeIttemOfFavorites = "$_baseURl/favorites/";

  //* Change Phone Number
  static final String cancelUpdatePhoneOtp =
      '$_baseURl/users/profile/phone/cancel/';
  static final String confirmUpdatePhone =
      '$_baseURl/users/profile/phone/confirm/';
}
