import 'package:dooss_business_app/user/core/network/api.dart';
import 'package:dooss_business_app/user/core/network/api_request.dart';
import 'package:dooss_business_app/user/core/network/api_urls.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'chat_remote_data_source.dart';

class ChatRemoteDataSourceImp implements ChatRemoteDataSource {
  final API api;

  ChatRemoteDataSourceImp({required this.api});

  @override
  Future<List<ChatModel>> fetchChats() async {
    try {
      print('Fetching chats from API...');
      final response = await api.get(
        apiRequest: ApiRequest(url: ApiUrls.chats),
      );
      print('API response: $response');
      return response.fold(
        (failure) {
          print('Failure: ${failure.message}');
          return <ChatModel>[];
        },
        (data) {
          print('Data received: $data');
          if (data is List) {
            return data.map((e) => ChatModel.fromJson(e)).toList();
          } else {
            print('Invalid data format received from API');
            return <ChatModel>[];
          }
        },
      );
    } catch (e) {
      print('ChatRemoteDataSource error: $e');
      return <ChatModel>[];
    }
  }

  @override
  Future<ChatModel> createChat(int dealerUserId) async {
    try {
      print('Creating chat with dealer_user_id: $dealerUserId');

      final response = await api.post<Map<String, dynamic>>(
        apiRequest: ApiRequest(
          url: ApiUrls.chats,
          data: {'dealer_user_id': dealerUserId},
        ),
      );

      print('API response: $response');
      return response.fold(
        (failure) {
          print('Failure: ${failure.message}');
          throw Exception('Failed to create chat: ${failure.message}');
        },
        (data) {
          print('Chat created successfully: $data');
          return ChatModel.fromJson(data);
        },
      );
    } catch (e) {
      print('ChatRemoteDataSource createChat error: $e');
      throw Exception('Failed to create chat: $e');
    }
  }

  @override
  Future<List<MessageModel>> fetchMessages(int chatId) async {
    try {
      print('Fetching messages from API with pagination...');
      final allMessages = <MessageModel>[];
      String? nextUrl = '${ApiUrls.chats}$chatId/messages/';
      int pageCount = 0;

      while (nextUrl != null) {
        pageCount++;
        final currentUrl = nextUrl!; // Safe to use ! since we checked != null
        print('Fetching page $pageCount: $currentUrl');
        
        final response = await api.get(
          apiRequest: ApiRequest(url: currentUrl),
        );
        
        final result = response.fold(
          (failure) {
            print('Failure on page $pageCount: ${failure.message}');
            return <MessageModel>[];
          },
          (data) {
            if (data is Map<String, dynamic>) {
              // Handle paginated response
              if (data['results'] is List) {
                final results = data['results'] as List;
                final pageMessages = results.map((e) => MessageModel.fromJson(e)).toList();
                print('Page $pageCount: Loaded ${pageMessages.length} messages');
                
                // Get next page URL
                nextUrl = data['next'] as String?;
                if (nextUrl != null) {
                  print('Next page URL: $nextUrl');
                } else {
                  print('No more pages. Total messages loaded: ${allMessages.length + pageMessages.length}');
                }
                
                return pageMessages;
              } else {
                print('Invalid data format: results is not a List');
                nextUrl = null;
                return <MessageModel>[];
              }
            } else if (data is List) {
              // Handle non-paginated response (fallback)
              print('Non-paginated response: ${data.length} messages');
              nextUrl = null;
              return data.map((e) => MessageModel.fromJson(e)).toList();
            } else {
              print('Invalid data format received from API');
              nextUrl = null;
              return <MessageModel>[];
            }
          },
        );
        
        allMessages.addAll(result);
      }
      
      print('✅ Fetched all messages: ${allMessages.length} total messages from $pageCount page(s)');
      return allMessages;
    } catch (e) {
      print('ChatRemoteDataSource fetchMessages error: $e');
      return <MessageModel>[];
    }
  }

  @override
  Future<MessageModel> sendMessage(int chatId, String content) async {
    try {
      print('Sending message to API...');
      final response = await api.post(
        apiRequest: ApiRequest(
          url: '${ApiUrls.chats}$chatId/messages/',
          data: {'text': content}, // Changed from 'content' to 'text'
        ),
      );
      print('API response: $response');
      return response.fold(
        (failure) {
          print('Failure: ${failure.message}');
          throw Exception('Failed to send message');
        },
        (data) {
          print('Data received: $data');
          return MessageModel.fromJson(data);
        },
      );
    } catch (e) {
      print('ChatRemoteDataSource sendMessage error: $e');
      throw Exception('Failed to send message');
    }
  }

  @override
  Future<Map<String, dynamic>?> markMessagesAsRead(
      int chatId, List<int> messageIds) async {
    try {
      print(
          'Marking messages as read for chat: $chatId with ${messageIds.length} message IDs');
      final url = '${ApiUrls.chats}$chatId/messages/mark-read/';
      print('Mark read URL: $url');

      // If messageIds is empty, don't send body (mark all as read)
      // Otherwise, send message_ids in body
      final ApiRequest apiRequest;
      if (messageIds.isEmpty) {
        print('Mark read: Sending empty body to mark ALL messages as read');
        apiRequest = ApiRequest(
          url: url,
          data: null, // No body - mark all as read
        );
      } else {
        print('Mark read data: {message_ids: $messageIds}');
        apiRequest = ApiRequest(
          url: url,
          data: {'message_ids': messageIds},
        );
      }

      final response = await api.post(
        apiRequest: apiRequest,
      );
      print('Mark read API response: $response');
      return response.fold(
        (failure) {
          print('Failure marking messages as read: ${failure.message}');
          return null;
        },
        (data) {
          print('Messages marked as read successfully: $data');
          if (data is Map<String, dynamic>) {
            return data;
          }
          return null;
        },
      );
    } catch (e) {
      print('ChatRemoteDataSource markMessagesAsRead error: $e');
      return null;
    }
  }
}
