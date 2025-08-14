import 'package:assignment/data/models/chat_model.dart';
import 'package:assignment/data/models/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../services/api_service.dart';

class ChatRepository {
  final ApiService apiService;
  late IO.Socket socket;

  ChatRepository(this.apiService) {
    socket = IO.io('http://45.129.87.38:6065', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.connect();
  }

  Future<List<ChatModel>> getUserChats(String userId) async {
    final response = await apiService.get('/chats/user-chats/$userId');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => ChatModel.fromJson(json))
          .toList();
    }
    throw Exception("Failed to load chats");
  }

  Future<List<MessageModel>> getChatMessages(String chatId) async {
    final response =
        await apiService.get('/messages/get-messagesformobile/$chatId');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => MessageModel.fromJson(json))
          .toList();
    }
    throw Exception("Failed to load messages");
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    required String messageType,
    String? fileUrl,
  }) async {
    socket.emit('send_message', {
      "chatId": chatId,
      "senderId": senderId,
      "content": content,
      "messageType": messageType,
      "fileUrl": fileUrl ?? ""
    });
  }

  void onMessageReceived(Function(MessageModel) callback) {
    socket.on('receive_message', (data) {
      callback(MessageModel.fromJson(data));
    });
  }
}
