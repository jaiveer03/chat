import 'package:assignment/data/repositories/chat_repository.dart';
import 'package:assignment/presentation/blocs/chat_bloc/chat_bloc.dart';
import 'package:assignment/presentation/blocs/chat_list_bloc/chat_list_bloc.dart';
import 'package:assignment/presentation/views/login_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/auth_repository.dart';
import 'data/services/api_service.dart';
import 'presentation/blocs/auth_bloc/auth_bloc.dart';

void main() {
  final dio = Dio(
    BaseOptions(
      baseUrl: "http://45.129.87.38:6065",
    ),
  );
  final apiService = ApiService(dio);
  final authRepository = AuthRepository(apiService);
  final chatRepository = ChatRepository(apiService);
  runApp(MyApp(
    authRepository: authRepository,
    chatRepository: chatRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ChatRepository chatRepository;

  const MyApp(
      {super.key, required this.authRepository, required this.chatRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository),
        ),
        BlocProvider<ChatListBloc>(
          create: (_) => ChatListBloc(chatRepository),
        ),
        BlocProvider<ChatBloc>(
          create: (_) => ChatBloc(chatRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(
          chatRepository: chatRepository,
        ),
        routes: {
          "/home": (context) => const Scaffold(
                body: Center(child: Text("Home Page Placeholder")),
              ),
        },
      ),
    );
  }
}
