// import 'dart:convert';
// import 'dart:developer';

// import 'package:doctors_data_med/core/storage/secure_storage.dart';
// import 'package:doctors_data_med/features/chat%20copy/data/model/last_message_model/last_message_model.dart';
// import 'package:doctors_data_med/global.dart' as globals;
// import 'package:web_socket_channel/status.dart' as status;
// import 'package:web_socket_channel/web_socket_channel.dart';

// class ChatSocket {
//   WebSocketChannel? channel;
//   final Function(LastMessageModel) onReceivedMessagePublic;
//   final Function(LastMessageModel) onReceivedMessagePrivate;
//   final Function(dynamic data) onCallEvent ;
//   bool _isConnected = false;

//   ChatSocket({
//     required this.onReceivedMessagePublic,
//     required this.onCallEvent,
//     required this.onReceivedMessagePrivate,
//   });

//   Future<void> initSocket() async {
//     log('DEBUG: Initializing ChatSocket...');
//     try {
//       final String? accessToken = await SecureStorage.getToken();
//       final String username = globals.username; // Assuming this exists
//       if (accessToken == null || accessToken.isEmpty) {
//         log('DEBUG: Error - Access token is null or empty');
//         return;
//       }
//       if (username.isEmpty) {
//         log('DEBUG: Error - Username is null or empty');
//         return;
//       }
//       log('DEBUG: Access token: $accessToken, Username: $username');

//       final wsUrl =
//           'ws://portainer.doctors.sy/wss/message/$username/?token=$accessToken';
//       log('DEBUG: Connecting to WebSocket URL: $wsUrl');
//       channel = WebSocketChannel.connect(Uri.parse(wsUrl));

//       log('DEBUG: Waiting for WebSocket connection to be ready...');
//       await channel!.ready;
//       log('DEBUG: WebSocket connection established');
//       channel!.sink.add('{"status": "online"}');
//       log('DEBUG: Sent online status');
//       _isConnected = true;

//       channel!.stream.listen(
//         (message) {
//           log('DEBUG: RESPONSE RECEIVED: $message');
//           try {
//             log('tyyyyyyyyyyyppppppppppppppppeeeeeeeee ${jsonDecode(message) is Map<String, dynamic>}');
//             // final messageData = LastMessageModel.fromJson(jsonDecode(message['message']));
//             final decodedMessage = jsonDecode(message) as Map<String, dynamic>;
//             if (decodedMessage.containsKey("status")) {
//               switch (decodedMessage["status"]) {
//                 case "new_call":
//                   log("DEBUG: Incoming call: ${decodedMessage['message']}");
//                   if (onCallEvent != null) {
//                     onCallEvent!(decodedMessage);
//                   }
//                   return;

//                 case "call_ended":
//                   log("DEBUG: Call ended: ${decodedMessage}");
//                   if (onCallEvent != null) {
//                     onCallEvent!(decodedMessage);
//                   }
//                   return;
//               }
//             } else {
//               final messageDataMap =
//                   decodedMessage['message'] as Map<String, dynamic>;
//               log('DEBUG: Extracted message JSON: $messageDataMap');
//               final messageData = LastMessageModel.fromJson(messageDataMap);
//               log('DEBUG: Parsed message: ${messageData.text} from ${messageData.sender}');
//               onReceivedMessagePublic(messageData);
//               onReceivedMessagePrivate(messageData);
//             }
//           } catch (e) {
//             log('DEBUG: Error parsing message: $e');
//           }
//         },
//         onError: (error) {
//           log('DEBUG: WebSocket error: $error');
//           _isConnected = false;
//           _reconnect();
//         },
//         onDone: () {
//           log('DEBUG: WebSocket connection closed');
//           _isConnected = false;
//           _reconnect();
//         },
//       );
//     } catch (e) {
//       log('DEBUG: WebSocket connection failed: $e');
//       _isConnected = false;
//       _reconnect();
//     }
//   }

//   void _reconnect() {
//     log('DEBUG: Scheduling reconnection attempt in 5 seconds...');
//     Future.delayed(const Duration(seconds: 5), () async {
//       if (!_isConnected) {
//         log('DEBUG: Attempting to reconnect to WebSocket...');
//         await initSocket();
//       } else {
//         log('DEBUG: Reconnection skipped - already connected');
//       }
//     });
//   }

//   void sendMessage(String text, String receiver) {
//     if (channel != null && _isConnected) {
//       final message = LastMessageModel(
//         id: 0, // ID will be set by the backend
//         text: text,
//         sender: '', // Will be set by the backend
//         receiverName: receiver,
//         dateTime: DateTime.now(),
//         isRead: false,
//       );
//       final messageJson = jsonEncode(message.toJson());
//       log('DEBUG: Sending message: $messageJson');
//       channel!.sink.add(messageJson);
//       log('DEBUG: Message sent successfully');
//     } else {
//       log('DEBUG: Cannot send message: WebSocket not connected');
//     }
//   }

//   void listenToChannel({required int conversationId}) {
//     log('DEBUG: Listening to channel conv-$conversationId (not implemented for direct WebSocket)');
//   }

//   void connectToPrivateChannel({
//     // required int conversationId,
//     required Function(LastMessageModel) onReceivedMessagePrivate,
//   }) {
//     // log(
//     //     'DEBUG: Connecting to private channel conv-$conversationId (handled via single WebSocket)');
//     // Messages are filtered by conversationId in the callback
//   }

//   void connectToPublicChannel() {
//     log('DEBUG: Connecting to public channel (handled via single WebSocket)');
//   }

//   void connect() {
//     log('DEBUG: Connect called (not needed for direct WebSocket)');
//   }

//   void leaveChannel({required int conversationId}) {
//     log('DEBUG: Leaving channel conv-$conversationId (no-op for direct WebSocket)');
//   }

//   void disconnect() {
//     log('DEBUG: Disconnecting WebSocket...');
//     channel?.sink.close(status.goingAway);
//     _isConnected = false;
//     log('DEBUG: WebSocket disconnected');
//   }
// }
