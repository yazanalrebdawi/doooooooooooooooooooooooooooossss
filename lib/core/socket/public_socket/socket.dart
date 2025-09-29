// import 'dart:convert';
// import 'dart:developer';

// import 'package:doctors_data_med/core/socket/public_socket/socket_logic.dart';
// import 'package:doctors_data_med/core/ui/widgets/cover_photo_widget.dart';
// import 'package:doctors_data_med/features/chat%20copy/cubit/chat_cubit.dart';
// import 'package:doctors_data_med/features/chat%20copy/cubit/chat_states.dart';
// import 'package:doctors_data_med/features/chat%20copy/data/model/conversation_model.dart';
// import 'package:doctors_data_med/features/chat%20copy/data/model/last_message_model/last_message_model.dart';
// import 'package:doctors_data_med/features/chat%20copy/ui/call_screen.dart';
// import 'package:doctors_data_med/features/chat%20copy/ui/chat_screen.dart';
// import 'package:doctors_data_med/features/chat%20copy/widgets/chat_card.dart';
// import 'package:doctors_data_med/features/chat%20copy/widgets/message_card.dart';
// import 'package:doctors_data_med/global.dart' as globals;
// import 'package:doctors_data_med/global.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:overlay_support/overlay_support.dart';

// // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// class SocketWidget extends StatefulWidget {
//   final Widget child;
//   final ValueChanged<bool> callBackSuccess;
//   const SocketWidget(
//       {super.key, required this.child, required this.callBackSuccess});

//   @override
//   State<SocketWidget> createState() => _SocketWidgetState();
// }

// class _SocketWidgetState extends State<SocketWidget> {
//   late OverlaySupportEntry overLay;
//   late ChatSocket _chatSocket;
//   bool autDismiss = true;

//   @override
//   void initState() {
//     super.initState();
//     log('DEBUG: Initializing SocketWidget...');
//     _chatSocket = ChatSocket(
//       onCallEvent: (data) {
//         switch (data["status"]) {
//           case "new_call":
//             final callData = data["message"];
//             final callMeta =
//                 callData["data"]; // <-- where sender/receiver/peer_id live
//             final callLogId = callData["call_log_id"];

//             log("DEBUG: Showing incoming call UI from ${callMeta['sender']}");

//             navigatorKey.currentState?.push(
//               MaterialPageRoute(
//                 builder: (context) => IncomingCallScreen(
//                   chatSocket: ChatSocketAdapter(
//                     (map) => _chatSocket.channel!.sink.add(jsonEncode(map)),
//                   ),
//                   sender: callMeta["sender"],
//                   receiver: callMeta["receiver"],
//                   peerId: callMeta["peer_id"],
//                   callLogId: callLogId,
//                 ),
//               ),
//             );
//             break;

//           case "call_ended":
//             log("DEBUG: Call ended. Closing call screen.");
//             navigatorKey.currentState?.popUntil((route) => route.isFirst);
//             break;
//         }
//       },
//       onReceivedMessagePublic: (message) {
//         log('DEBUG: Public message received: ${message.text} from ${message.sender}');
//         // Assuming NotificationSocketPublicModel can be derived from Message
//         // Adjust based on actual NotificationSocketPublicModel structure
//         final notification = {
//           'notification': {
//             'conversationId': 0, // Adjust based on message data
//             'name': message.sender,
//             // 'photo': message.attachmentDetails,
//             'message': message.text,
//           }
//         };
//         NotificationSocketPublicModel notificationSocketPublicModel =
//             NotificationSocketPublicModel.fromJson(
//                 notification['notification']!);
//         {
//           log('DEBUG: Showing notification for message: ${message.text}');
//           setState(() {
//             overLay = showSimpleNotification(
//               autoDismiss: autDismiss,
//               InkWell(
//                 onTap: () {
//                   log('DEBUG: Notification tapped');
//                   autDismiss = false;
//                   overLay.dismiss();
//                   autDismiss = true;
//                   context.read<ChatCubit>().chatScreenClear();
//                   navigatorKey.currentState?.push(MaterialPageRoute(
//                       builder: (context) => ChatScreen(
//                             receiverName:
//                                 notificationSocketPublicModel.name ?? '',
//                             conversationModel: ConversationModel(
//                               username: notificationSocketPublicModel.name,
//                             ),
//                           )));
//                 },
//                 child: Align(
//                   alignment: AlignmentDirectional.topStart,
//                   child: Text(notificationSocketPublicModel.name ?? ''),
//                 ),
//               ),
//               background: Colors.green,
//               elevation: 0.1,
//               leading: InkWell(
//                 onTap: () {
//                   log('DEBUG: Notification leading tapped');
//                   context.read<ChatCubit>().chatScreenClear();
//                   navigatorKey.currentState?.push(MaterialPageRoute(
//                       builder: (context) => ChatScreen(
//                             receiverName:
//                                 notificationSocketPublicModel.name ?? '',
//                             conversationModel: ConversationModel(
//                               username: notificationSocketPublicModel.name,
//                             ),
//                           )));
//                   autDismiss = false;
//                   overLay.dismiss();
//                   autDismiss = true;
//                 },
//                 child: SizedBox(
//                   height: 50,
//                   width: 50,
//                   child: CoverPhotoWidget(
//                     photoUrl: notificationSocketPublicModel.photo ?? '',
//                   ),
//                 ),
//               ),
//               subtitle: (notificationSocketPublicModel.message
//                           ?.startsWith('<div>') ??
//                       false)
//                   ? InkWell(
//                       onTap: () {
//                         context.read<ChatCubit>().chatScreenClear();
//                         navigatorKey.currentState?.push(MaterialPageRoute(
//                             builder: (context) => ChatScreen(
//                                   receiverName:
//                                       notificationSocketPublicModel.name ?? '',
//                                   conversationModel: ConversationModel(
//                                     username:
//                                         notificationSocketPublicModel.name,
//                                   ),
//                                 )));
//                         log('DEBUG: Notification subtitle (HTML) tapped');
//                         autDismiss = false;
//                         overLay.dismiss();
//                         autDismiss = true;
//                       },
//                       child: Html(data: notificationSocketPublicModel.message),
//                     )
//                   : InkWell(
//                       onTap: () {
//                         context.read<ChatCubit>().chatScreenClear();
//                         navigatorKey.currentState?.push(MaterialPageRoute(
//                             builder: (context) => ChatScreen(
//                                   receiverName:
//                                       notificationSocketPublicModel.name ?? '',
//                                   conversationModel: ConversationModel(
//                                     username:
//                                         notificationSocketPublicModel.name,
//                                   ),
//                                 )));
//                         log('DEBUG: Notification subtitle tapped');
//                         autDismiss = false;
//                         overLay.dismiss();
//                         autDismiss = true;
//                       },
//                       child: Text(
//                         notificationSocketPublicModel.message != ''
//                             ? notificationSocketPublicModel.message ?? ''
//                             : 'attachment',
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//               duration: const Duration(seconds: 5),
//               trailing: InkWell(
//                 onTap: () {
//                   context.read<ChatCubit>().chatScreenClear();
//                   navigatorKey.currentState?.push(MaterialPageRoute(
//                       builder: (context) => ChatScreen(
//                             receiverName:
//                                 notificationSocketPublicModel.name ?? '',
//                             conversationModel: ConversationModel(
//                               username: notificationSocketPublicModel.name,
//                             ),
//                           )));
//                   log('DEBUG: Notification trailing tapped');
//                   autDismiss = false;
//                   overLay.dismiss();
//                   autDismiss = true;
//                 },
//                 child: Container(
//                   width: 20,
//                 ),
//               ),
//             );
//           });
//           if (context.read<ChatCubit>().allConversationList.isNotEmpty) {
//             log('DEBUG: Updating conversation list with new message');
//             context
//                 .read<ChatCubit>()
//                 .allConversationList
//                 .removeWhere((element) {
//               return element.username == notificationSocketPublicModel.name;
//             });
//             context.read<ChatCubit>().allConversationList.insert(
//                   0,
//                   ConversationModel(
//                     id: notificationSocketPublicModel.conversationId,
//                     username: notificationSocketPublicModel.name,
//                     photo: notificationSocketPublicModel.photo,
//                   ),
//                 );
//             context.read<ChatCubit>().allConversationWidgetList.insert(
//                   0,
//                   ChatCard(
//                     whenDone: () => setState(() {}),
//                     conversationModel: ConversationModel(
//                       id: notificationSocketPublicModel.conversationId,
//                       username: notificationSocketPublicModel.name,
//                       photo: notificationSocketPublicModel.photo,
//                     ),
//                   ),
//                 );
//             if (context.read<ChatCubit>().whenDone != null && mounted) {
//               log('DEBUG: Calling ChatCubit whenDone callback');
//               context.read<ChatCubit>().whenDone!();
//             }
//           }
//         }
//       },
//       onReceivedMessagePrivate: (message) {
//         log('DEBUG: Private message received in SocketWidget (handled elsewhere)');
//         log('DEBUG: PrivateSocket received message: ${message.text} from ${message.sender}');
//         // Assuming SocketMessageModel can parse Message or is compatible
//         LastMessageModel socketMessageModel =
//             LastMessageModel.fromJson(message.toJson());
//         if (socketMessageModel.sender != globals.username) {
//           log('DEBUG: Processing message from sender: ${socketMessageModel.sender}');
//           if (socketMessageModel.attachments == null) {
//             log('DEBUG: No attachment, adding text message to ChatCubit');
//             context.read<ChatCubit>().msgList.insert(0, socketMessageModel);
//             context.read<ChatCubit>().widgetList.insert(
//                   0,
//                   MessageCardWidget(
//                     whenDone: () => () {},
//                     messageModel: socketMessageModel,
//                     fromReciever: globals.username != socketMessageModel.sender,
//                   ),
//                 );
//             context.read<ChatCubit>().emit(ChatUpdatedState(
//                   List.from(context.read<ChatCubit>().msgList),
//                 ));
//           } else {
//             log('DEBUG: Attachment present, fetching conversation details');
//             // ResponseResult<LastMessageModel> result =
//             //     await GetConversationByOneUseCase(ChatRepository()).call(
//             //   params: GetConversationByOneParams(
//             //     msgId: socketMessageModel.id ?? 0,
//             //   ),
//             // );
//             context.read<ChatCubit>().msgList.insert(0, socketMessageModel);
//             context.read<ChatCubit>().widgetList.insert(
//                   0,
//                   MessageCardWidget(
//                     whenDone: () => widget.callBackSuccess(true),
//                     messageModel: socketMessageModel,
//                     fromReciever: globals.username != socketMessageModel.sender,
//                   ),
//                 );
//             context.read<ChatCubit>().emit(ChatUpdatedState(
//                   List.from(context.read<ChatCubit>().msgList),
//                 ));
//           }
//           if (mounted) {
//             log('DEBUG: Updating UI and calling success callback');
//             setState(() {});
//             // widget.callBackSuccess(true);
//           }
//         } else {
//           log('DEBUG: Message from self, ignoring');
//         }
//       },
//     );
//     _chatSocket.initSocket().then((_) {
//       log('DEBUG: ChatSocket initialized successfully');
//       _chatSocket.connectToPublicChannel();
//       context.read<ChatCubit>().chatSocket = _chatSocket;
//     }).catchError((e) {
//       log('DEBUG: ChatSocket initialization failed: $e');
//     });
//   }

//   @override
//   void dispose() {
//     log('DEBUG: Disposing SocketWidget...');
//     _chatSocket.disconnect();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     log('DEBUG: Building SocketWidget');
//     return widget.child;
//   }
// }

// // Placeholder for NotificationSocketPublicModel (adjust based on actual model)
// class NotificationSocketPublicModel {
//   final int? conversationId;
//   final String? name;
//   final String? photo;
//   final String? message;

//   NotificationSocketPublicModel({
//     this.conversationId,
//     this.name,
//     this.photo,
//     this.message,
//   });

//   factory NotificationSocketPublicModel.fromJson(Map<String, dynamic> json) {
//     return NotificationSocketPublicModel(
//       conversationId: json['conversationId'] as int?,
//       name: json['name'] as String?,
//       photo: json['photo'] as String?,
//       message: json['message'] as String?,
//     );
//   }
// }
