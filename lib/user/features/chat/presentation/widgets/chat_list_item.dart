import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/locator_service.dart' as di;
import '../../../../core/services/storage/secure_storage/secure_storage_service.dart';
import '../../../../core/services/storage/shared_preferances/shared_preferences_service.dart';
import '../../data/models/chat_model.dart';

class ChatListItem extends StatefulWidget {
  final ChatModel chat;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.chat,
    required this.onTap,
  });

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  bool _isDealer = false;

  @override
  void initState() {
    super.initState();
    _checkIfDealer();
  }

  Future<void> _checkIfDealer() async {
    final secureStorage = di.appLocator<SecureStorageService>();
    final sharedPrefsService = di.appLocator<SharedPreferencesService>();
    bool isDealer = await secureStorage.getIsDealer();
    if (!isDealer) {
      final dealerData = await sharedPrefsService.getDealerAuthData();
      isDealer = dealerData != null;
    }
    if (mounted) {
      setState(() {
        _isDealer = isDealer;
      });
    }
  }

  // Extract name from user field (format: "name (+phone) - user")
  String _extractUserName(String userField) {
    if (userField.isEmpty) return '';
    // Extract name before the first "("
    final nameMatch = RegExp(r'^([^(]+)').firstMatch(userField.trim());
    if (nameMatch != null) {
      return nameMatch.group(1)?.trim() ?? '';
    }
    return userField;
  }

  // Get the participant name to display
  String _getParticipantName() {
    if (_isDealer) {
      // If current user is dealer, show the user's name (extracted from user field)
      final userName = _extractUserName(widget.chat.user);
      return userName.isNotEmpty ? userName : 'Unknown User';
    } else {
      // If current user is regular user, show the dealer's name
      return widget.chat.dealer.isNotEmpty ? widget.chat.dealer : 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Get the appropriate unread count based on user type
    final unreadCount =
        _isDealer ? widget.chat.dealerUnreadCount : widget.chat.userUnreadCount;

    final participantName = _getParticipantName();

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        margin: EdgeInsets.only(bottom: 1.h),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF2A2A2A) : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: AppColors.gray.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 24.sp,
                    color: AppColors.primary,
                  ),
                ),
                // Online indicator (green dot)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(width: 12.w),

            // Chat Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          participantName,
                          style: AppTextStyles.s16w600.copyWith(
                            color: AppColors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTimestamp(widget.chat.createdAt),
                        style: AppTextStyles.s12w400.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.chat.lastMessage?.text.isNotEmpty == true
                              ? widget.chat.lastMessage!.text
                              : 'No messages yet',
                          style: AppTextStyles.s14w400.copyWith(
                            color: AppColors.gray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Unread message indicator
                      if (unreadCount > 0) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$unreadCount',
                            style: AppTextStyles.s12w400.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${date.day}/${date.month}';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m';
      } else {
        return 'now';
      }
    } catch (e) {
      return 'now';
    }
  }
}
