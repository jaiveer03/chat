class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String messageType;
  final String? fileUrl;
  final DateTime createdAt;
  final String? status;
  final DateTime? sentAt;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.messageType,
    this.fileUrl,
    required this.createdAt,
    this.status,
    this.sentAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      chatId: json['chatId'] ?? '',
      senderId: json['senderId'] ?? '',
      content: json['content'] ?? '',
      messageType: json['messageType'] ?? '',
      fileUrl: json['fileUrl'],
      status: json['status'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      sentAt: json['sentAt'] != null ? DateTime.tryParse(json['sentAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "chatId": chatId,
      "senderId": senderId,
      "content": content,
      "messageType": messageType,
      "fileUrl": fileUrl,
      "status": status,
      "createdAt": createdAt.toIso8601String(),
      "sentAt": sentAt?.toIso8601String(),
    };
  }
}
