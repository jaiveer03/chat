import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/chat_repository.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository chatRepository;

  ChatListBloc(this.chatRepository) : super(ChatListInitial()) {
    on<FetchUserChats>(_onFetchUserChats);
  }

  Future<void> _onFetchUserChats(
    FetchUserChats event,
    Emitter<ChatListState> emit,
  ) async {
    emit(ChatListLoading());
    try {
      final chats = await chatRepository.getUserChats(event.userId);
      emit(ChatListLoaded(chats));
    } catch (e) {
      emit(ChatListError(e.toString()));
    }
  }
}
