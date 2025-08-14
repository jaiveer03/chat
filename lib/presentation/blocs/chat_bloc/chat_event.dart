part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatMessages extends ChatEvent {
  final String chatId;
  const LoadChatMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SendChatMessage extends ChatEvent {
  final String chatId;
  final String senderId;
  final String content;
  final String messageType;
  final String? fileUrl;

  const SendChatMessage({
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.messageType,
    this.fileUrl,
  });

  @override
  List<Object?> get props => [chatId, senderId, content, messageType, fileUrl];
}

class ReceiveChatMessage extends ChatEvent {
  final MessageModel message;

  const ReceiveChatMessage(this.message);

  @override
  List<Object?> get props => [message];
}
