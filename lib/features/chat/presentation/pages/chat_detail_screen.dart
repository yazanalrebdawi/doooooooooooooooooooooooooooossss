// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:dooss_business_app/features/chat/data/models/message_model.dart';
// import 'package:dooss_business_app/features/chat/data/models/chat_model.dart';

// class ChatDetailScreen extends StatefulWidget {
//   final ChatModel chat;

//   const ChatDetailScreen({super.key, required this.chat});

//   @override
//   State<ChatDetailScreen> createState() => _ChatDetailScreenState();
// }

// class _ChatDetailScreenState extends State<ChatDetailScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<MessageModel> messages = [
//     MessageModel(
//       id: '1',
//       text: 'Hello!',
//       time: '10:40 Pm',
//       type: MessageType.received,
//     ),
//     MessageModel(
//       id: '2',
//       text: 'Is This Vehicle Available For Buy?',
//       time: '10:40 Pm',
//       type: MessageType.received,
//     ),
//     MessageModel(
//       id: '3',
//       text: 'Yes, it is.',
//       time: '10:41 Pm',
//       type: MessageType.sent,
//     ),
//     MessageModel(
//       id: '4',
//       text: 'How much does it cost?',
//       time: '10:42 Pm',
//       type: MessageType.sent,
//     ),
//   ];

//   final List<String> suggestionChats = [
//     'Any Other Cars? That I Can Buy?',
//     'How Much It Costs?',
//     'Is The Price Negotiable?',
//   ];

//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Row(
//           children: [
//             CircleAvatar(
//               radius: 20.w,
//               backgroundImage: widget.chat.imageUrl != null
//                   ? NetworkImage(widget.chat.imageUrl!)
//                   : null,
//               child: widget.chat.imageUrl == null
//                   ? Icon(Icons.person, size: 20.w)
//                   : null,
//             ),
//             SizedBox(width: 8.w),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.chat.userName,
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   'Last Online 15 Minutes Ago',
//                   style: TextStyle(
//                     fontSize: 10.sp,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add_circle_outline),
//             onPressed: () {
//               // Handle add button
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 reverse: true,
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//                 itemCount: messages.length,
//                 itemBuilder: (context, index) {
//                   final message = messages[index];
//                   // Message bubble will be implemented here
//                   return Align(
//                     alignment: message.type == MessageType.sent
//                         ? Alignment.centerRight
//                         : Alignment.centerLeft,
//                     child: Container(
//                       margin: EdgeInsets.symmetric(vertical: 4.h),
//                       padding: EdgeInsets.all(12.w),
//                       decoration: BoxDecoration(
//                         color: message.type == MessageType.sent
//                             ? Colors.brown.shade700
//                             : Colors.grey.shade200,
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: message.type == MessageType.sent
//                             ? CrossAxisAlignment.end
//                             : CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             message.text,
//                             style: TextStyle(
//                               color: message.type == MessageType.sent
//                                   ? Colors.white
//                                   : Colors.black87,
//                               fontSize: 14.sp,
//                             ),
//                           ),
//                           SizedBox(height: 4.h),
//                           Text(
//                             message.time,
//                             style: TextStyle(
//                               color: message.type == MessageType.sent
//                                   ? Colors.white70
//                                   : Colors.grey.shade600,
//                               fontSize: 10.sp,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Suggestion Chat',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   SizedBox(
//                     height: 40.h,
//                     child: ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: suggestionChats.length,
//                       separatorBuilder: (context, index) => SizedBox(width: 8.w),
//                       itemBuilder: (context, index) {
//                         return ActionChip(
//                           label: Text(suggestionChats[index]),
//                           onPressed: () {
//                             _messageController.text = suggestionChats[index];
//                           },
//                           labelStyle: TextStyle(
//                             fontSize: 12.sp,
//                             color: Colors.black87,
//                           ),
//                           backgroundColor: Colors.grey.shade200,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.r),
//                             side: BorderSide.none,
//                           ),
//                           padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _messageController,
//                           decoration: InputDecoration(
//                             hintText: 'Type Your Message Here',
//                             hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
//                             filled: true,
//                             fillColor: Colors.grey.shade200,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8.r),
//                               borderSide: BorderSide.none,
//                             ),
//                             contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 8.w),
//                       CircleAvatar(
//                         radius: 24.w,
//                         backgroundColor: Colors.brown.shade700,
//                         child: IconButton(
//                           icon: const Icon(Icons.send, color: Colors.white),
//                           onPressed: () {
//                             // Handle send message
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// } 