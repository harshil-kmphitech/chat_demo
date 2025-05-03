import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'chat_user_model.g.dart';

ChatUserModel chatUserModelFromJson(String str) => ChatUserModel.fromJson(json.decode(str));

String chatUserModelToJson(ChatUserModel data) => json.encode(data.toJson());

@JsonSerializable()
class ChatUserModel {
  final bool? status;
  final String? message;
  final ChatUserData? data;

  ChatUserModel({
    this.status,
    this.message,
    this.data,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) => _$ChatUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatUserModelToJson(this);
}

@JsonSerializable()
class ChatUserData {
  final List<ChatList>? chatList;
  final int? totalRecords;

  ChatUserData({
    this.chatList,
    this.totalRecords,
  });

  factory ChatUserData.fromJson(Map<String, dynamic> json) => _$ChatUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChatUserDataToJson(this);
}

@JsonSerializable()
class ChatList {
  final int? unreadmessageCount;
  final LastMessage? lastMessage;
  final Details? senderUserDetails;
  final Details? chatDetails;
  final String? roomId;
  final String? chatType;
  final String? deletedAt;
  final DateTime? createdAt;

  ChatList({
    this.unreadmessageCount,
    this.lastMessage,
    this.senderUserDetails,
    this.chatDetails,
    this.roomId,
    this.chatType,
    this.deletedAt,
    this.createdAt,
  });

  factory ChatList.fromJson(Map<String, dynamic> json) => _$ChatListFromJson(json);

  Map<String, dynamic> toJson() => _$ChatListToJson(this);
}

@JsonSerializable()
class Details {
  final String? userId;
  final String? name;
  final String? profile;

  Details({
    this.userId,
    this.name,
    this.profile,
  });

  factory Details.fromJson(Map<String, dynamic> json) => _$DetailsFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsToJson(this);
}

@JsonSerializable()
class LastMessage {
  final DateTime? createdAt;
  final String? message;
  final String? senderId;

  LastMessage({
    this.createdAt,
    this.message,
    this.senderId,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => _$LastMessageFromJson(json);

  Map<String, dynamic> toJson() => _$LastMessageToJson(this);
}
