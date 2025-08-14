import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/chat_user_model.dart';
import '../../data/models/message_model.dart';
import '../../data/repositories/chat_repository.dart';
import '../blocs/chat_bloc/chat_bloc.dart';

class ChatView extends StatefulWidget {
  final String chatId;
  final ChatUserModel currentUser;
  final ChatUserModel otherUser;
  final ChatRepository chatRepository;

  const ChatView({
    super.key,
    required this.chatId,
    required this.currentUser,
    required this.otherUser,
    required this.chatRepository,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;
  late final ChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _chatBloc = ChatBloc(widget.chatRepository);
    _chatBloc.add(LoadChatMessages(widget.chatId));
    widget.chatRepository.onMessageReceived((MessageModel message) {
      if (message.chatId == widget.chatId) {
        _chatBloc.add(ReceiveChatMessage(message));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _chatBloc.close();
    super.dispose();
  }

  void _sendMessage() {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    _chatBloc.add(SendChatMessage(
      chatId: widget.chatId,
      senderId: widget.currentUser.id,
      content: content,
      messageType: 'text',
      fileUrl: null,
    ));
    _controller.clear();
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 80,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildMessageItem(MessageModel message) {
    final isMe = message.senderId == widget.currentUser.id;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.content,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.otherUser.name),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatLoaded) {
                    final messages = state.messages;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    });
                    if (messages.isEmpty) {
                      return const Center(child: Text('No messages yet'));
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) =>
                          _buildMessageItem(messages[index]),
                    );
                  } else if (state is ChatError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration:
                            const InputDecoration(hintText: 'Type a message'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
