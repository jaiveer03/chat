import 'package:assignment/data/models/message_model.dart';
import 'package:assignment/data/repositories/chat_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc(this.chatRepository) : super(ChatLoading()) {
    on<LoadChatMessages>(_onLoadChatMessages);
    on<SendChatMessage>(_onSendChatMessage);
    on<ReceiveChatMessage>(_onReceiveChatMessage);
  }

  Future<void> _onLoadChatMessages(
      LoadChatMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messages = await chatRepository.getChatMessages(event.chatId);

      // Listen for real-time messages
      chatRepository.onMessageReceived((message) {
        add(ReceiveChatMessage(message));
      });

      emit(ChatLoaded(messages: messages));
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  Future<void> _onSendChatMessage(
      SendChatMessage event, Emitter<ChatState> emit) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;

      // Send message via socket
      chatRepository.sendMessage(
        chatId: event.chatId,
        senderId: event.senderId,
        content: event.content,
        messageType: event.messageType,
        fileUrl: event.fileUrl,
      );

      final tempMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: event.chatId,
        senderId: event.senderId,
        content: event.content,
        messageType: event.messageType,
        fileUrl: event.fileUrl,
        createdAt: DateTime.now(),
      );

      final updatedMessages = List<MessageModel>.from(currentState.messages)
        ..add(tempMessage);

      emit(ChatLoaded(messages: updatedMessages));
    }
  }


  Future<void> _onReceiveChatMessage(
      ReceiveChatMessage event, Emitter<ChatState> emit) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final updatedMessages = List<MessageModel>.from(currentState.messages)
        ..add(event.message);

      emit(ChatLoaded(messages: updatedMessages));
    }
  }
}
