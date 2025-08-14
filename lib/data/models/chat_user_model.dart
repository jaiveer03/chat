class ChatUserModel {
  final String id;
  final String name;
  final String lastMessage;

  ChatUserModel({
    required this.id,
    required this.name,
    required this.lastMessage,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'lastMessage': lastMessage,
    };
  }
}
