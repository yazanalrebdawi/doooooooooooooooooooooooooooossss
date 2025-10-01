// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:dooss_business_app/features/chat/data/models/chat_model.dart';
// import 'package:dooss_business_app/features/chat/presentation/widgets/no_conversation_yet_widget.dart';
// import 'package:dooss_business_app/features/chat/presentation/widgets/chat_item_widget.dart';
// import 'package:dooss_business_app/core/routes/route_names.dart';
// import 'package:go_router/go_router.dart';

// class ChatListScreen extends StatefulWidget {
//   const ChatListScreen({super.key});

//   @override
//   State<ChatListScreen> createState() => _ChatListScreenState();
// }

// class _ChatListScreenState extends State<ChatListScreen> {
//   bool hasChats = true; // Changed to true to show the chat list initially
//   final TextEditingController _searchController = TextEditingController();

//   final List<ChatModel> chats = [
//     ChatModel(
//       id: '1',
//       userName: 'Eman Emad',
//       lastMessage: 'Is This Vehicle Available For Buy?',
//       time: '10:40 Pm',
//       imageUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
//       unreadCount: 2,
//     ),
//     ChatModel(
//       id: '2',
//       userName: 'Ammar Salah',
//       lastMessage: 'Great Car, love It!',
//       time: '10:00 Pm',
//       imageUrl: 'https://randomuser.me/api/portraits/men/2.jpg',
//     ),
//     ChatModel(
//       id: '3',
//       userName: 'Maryem Ibrahim',
//       lastMessage: 'Sure No Problem',
//       time: '9:40 Pm',
//       imageUrl: 'https://randomuser.me/api/portraits/women/3.jpg',
//     ),
//     ChatModel(
//       id: '4',
//       userName: 'Alaa Mahmoud',
//       lastMessage: 'Thank You Very Much!',
//       time: '9:00 Pm',
//       imageUrl: 'https://randomuser.me/api/portraits/women/4.jpg',
//     ),
//     ChatModel(
//       id: '5',
//       userName: 'Omar Ragab',
//       lastMessage: 'Yes, You Can Pick Up!',
//       time: '8:00 Pm',
//       imageUrl: 'https://randomuser.me/api/portraits/men/5.jpg',
//     ),
//     ChatModel(
//       id: '6',
//       userName: 'Karim Ahmed',
//       lastMessage: 'No Problem',
//       time: '11:00 Am',
//       imageUrl: 'https://randomuser.me/api/portraits/men/6.jpg',
//     ),
//   ];

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             // Handle back button
//           },
//         ),
//         title: Text(
//           'Message',
//           style: TextStyle(
//             fontSize: 20.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             if (!hasChats)
//               const NoConversationYetWidget()
//             else
//               Column(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//                     child: TextField(
//                       controller: _searchController,
//                       decoration: InputDecoration(
//                         hintText: 'Search For Message Here',
//                         hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
//                         prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
//                         filled: true,
//                         fillColor: Colors.grey.shade200,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.r),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(vertical: 0.h),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView.separated(
//                       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//                       itemCount: chats.length,
//                       separatorBuilder: (context, index) => SizedBox(height: 8.h),
//                       itemBuilder: (context, index) {
//                         final chat = chats[index];
//                         return ChatItemWidget(
//                           chat: chat,
//                           onTap: () {
//                             context.go(RouteNames.chatDetails, extra: chat);
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: 24.h, left: 16.w, right: 16.w),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Handle Add New Chat
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.brown.shade700,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 12.h),
//                     ),
//                     child: Text(
//                       'Add New Chat',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// } 