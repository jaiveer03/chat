import 'package:assignment/data/models/chat_user_model.dart';

class ChatModel {
  final String id;
  final LastMessageModel? lastMessage;
  final List<ChatUserModel> participants;

  ChatModel({
    required this.id,
    this.lastMessage,
    required this.participants,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] ?? '',
      lastMessage: json['lastMessage'] != null
          ? LastMessageModel.fromJson(json['lastMessage'])
          : null,
      participants: (json['participants'] as List)
          .map((u) => ChatUserModel.fromJson(u))
          .toList(),
    );
  }
}

class LastMessageModel {
  final String id;
  final String senderId;
  final String content;
  final String messageType;
  final String? fileUrl;
  final DateTime createdAt;

  LastMessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.messageType,
    this.fileUrl,
    required this.createdAt,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      id: json['_id'] ?? '',
      senderId: json['senderId'] ?? '',
      content: json['content'] ?? '',
      messageType: json['messageType'] ?? '',
      fileUrl: json['fileUrl'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
