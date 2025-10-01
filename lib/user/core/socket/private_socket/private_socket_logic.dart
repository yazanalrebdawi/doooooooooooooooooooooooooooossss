// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class PrivateSocket extends StatefulWidget {
//   // final int conversationId;
//   final ValueChanged<bool> callBackSuccess;

//   const PrivateSocket({
//     super.key,
//     // required this.conversationId,
//     required this.callBackSuccess,
//   });

//   @override
//   State<PrivateSocket> createState() => _PrivateSocketState();
// }

// class _PrivateSocketState extends State<PrivateSocket> {
//   @override
//   void initState() {
//     super.initState();
//     log('DEBUG: Initializing PrivateSocket for conversationId: ');
//     // context.read<ChatCubit>().conversationId = widget.conversationId;
//     context.read<ChatCubit>().chatSocket?.connectToPrivateChannel(
//           // conversationId: widget.conversationId,
//           onReceivedMessagePrivate: (message) async {
//             log('DEBUG: PrivateSocket received message: ${message.text} from ${message.sender}');
//             // Assuming SocketMessageModel can parse Message or is compatible
//             LastMessageModel socketMessageModel = LastMessageModel.fromJson(message.toJson());
//             if (socketMessageModel.sender != globals.username) {
//               log('DEBUG: Processing message from sender: ${socketMessageModel.sender}');
//               if (socketMessageModel.attachments == null) {
//                 log('DEBUG: No attachment, adding text message to ChatCubit');
//                 context.read<ChatCubit>().msgList.insert(
//                       0,
//                       socketMessageModel
//                     );
//                 context.read<ChatCubit>().widgetList.insert(
//                       0,
//                       MessageCardWidget(
//                         whenDone: () => widget.callBackSuccess(true),
//                         messageModel: socketMessageModel,
//                         fromReciever: globals.username != socketMessageModel.sender,
//                       ),
//                     );
//               } else {
//                 log('DEBUG: Attachment present, fetching conversation details');
//                 ResponseResult<LastMessageModel> result =
//                     await GetConversationByOneUseCase(ChatRepository()).call(
//                   params: GetConversationByOneParams(
//                     msgId: socketMessageModel.id ?? 0,
//                   ),
//                 );
//                 context.read<ChatCubit>().msgList.insert(0, result.data!);
//                 context.read<ChatCubit>().widgetList.insert(
//                       0,
//                       MessageCardWidget(
//                         whenDone: () => widget.callBackSuccess(true),
//                         messageModel: result.data!,
//                         fromReciever: globals.username != socketMessageModel.sender,
//                       ),
//                     );
//               }
//               if (mounted) {
//                 log('DEBUG: Updating UI and calling success callback');
//                 setState(() {});
//                 widget.callBackSuccess(true);
//               }
//             } else {
//               log('DEBUG: Message from self, ignoring');
//             }
//           },
//         );
//   }

//   @override
//   void dispose() {
//     log('DEBUG: Disposing PrivateSocket for conversationId:');
//     // context.read<ChatCubit>().chatSocket?.leaveChannel(conversationId: widget.conversationId);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     log('DEBUG: Building PrivateSocket (empty widget)');
//     return const SizedBox();
//   }
// }