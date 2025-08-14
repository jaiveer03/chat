part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<MessageModel> messages;

  const ChatLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class ChatError extends ChatState {
  final String message;
  const ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}
