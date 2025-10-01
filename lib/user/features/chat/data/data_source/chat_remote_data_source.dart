import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> fetchChats();
  Future<ChatModel> createChat(int dealerUserId);
  Future<List<MessageModel>> fetchMessages(int chatId);
  Future<MessageModel> sendMessage(int chatId, String content);
}
