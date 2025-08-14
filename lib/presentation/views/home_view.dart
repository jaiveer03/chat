import 'package:assignment/data/models/chat_user_model.dart';
import 'package:assignment/data/repositories/chat_repository.dart';
import 'package:assignment/presentation/blocs/chat_list_bloc/chat_list_bloc.dart';
import 'package:assignment/presentation/blocs/chat_list_bloc/chat_list_event.dart';
import 'package:assignment/presentation/blocs/chat_list_bloc/chat_list_state.dart';
import 'package:assignment/presentation/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';

class HomePage extends StatefulWidget {
  final UserModel user;
  final ChatRepository chatRepository;
  const HomePage({super.key, required this.user, required this.chatRepository});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatListBloc>().add(FetchUserChats(widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats - ${widget.user.role}")),
      body: BlocBuilder<ChatListBloc, ChatListState>(
        builder: (context, state) {
          if (state is ChatListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatListLoaded) {
            if (state.chats.isEmpty) {
              return const Center(child: Text("No chats available"));
            }
            return ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                final chat = state.chats[index];
                final otherUser = chat.participants.firstWhere(
                  (u) => u.id != widget.user.id,
                  orElse: () =>
                      ChatUserModel(id: '', name: 'Unknown', lastMessage: ''),
                );

                return ListTile(
                  title: Text(otherUser.name),
                  subtitle: Text(
                    chat.lastMessage != null &&
                            chat.lastMessage!.content.isNotEmpty
                        ? chat.lastMessage!.content
                        : 'No messages yet',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatView(
                          chatId: chat.id,
                          currentUser: ChatUserModel(
                            id: widget.user.id,
                            name: widget.user.email,
                            lastMessage: '',
                          ),
                          otherUser: otherUser,
                          chatRepository: widget.chatRepository,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is ChatListError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
