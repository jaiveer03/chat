import 'package:equatable/equatable.dart';

abstract class ChatListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserChats extends ChatListEvent {
  final String userId;
  FetchUserChats(this.userId);

  @override
  List<Object?> get props => [userId];
}
