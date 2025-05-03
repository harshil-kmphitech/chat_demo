// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUserModel _$ChatUserModelFromJson(Map<String, dynamic> json) =>
    ChatUserModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ChatUserData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatUserModelToJson(ChatUserModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

ChatUserData _$ChatUserDataFromJson(Map<String, dynamic> json) => ChatUserData(
      chatList: (json['chatList'] as List<dynamic>?)
          ?.map((e) => ChatList.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRecords: (json['totalRecords'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChatUserDataToJson(ChatUserData instance) =>
    <String, dynamic>{
      'chatList': instance.chatList,
      'totalRecords': instance.totalRecords,
    };

ChatList _$ChatListFromJson(Map<String, dynamic> json) => ChatList(
      unreadmessageCount: (json['unreadmessageCount'] as num?)?.toInt(),
      lastMessage: json['lastMessage'] == null
          ? null
          : LastMessage.fromJson(json['lastMessage'] as Map<String, dynamic>),
      senderUserDetails: json['senderUserDetails'] == null
          ? null
          : Details.fromJson(json['senderUserDetails'] as Map<String, dynamic>),
      chatDetails: json['chatDetails'] == null
          ? null
          : Details.fromJson(json['chatDetails'] as Map<String, dynamic>),
      roomId: json['roomId'] as String?,
      chatType: json['chatType'] as String?,
      deletedAt: json['deletedAt'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ChatListToJson(ChatList instance) => <String, dynamic>{
      'unreadmessageCount': instance.unreadmessageCount,
      'lastMessage': instance.lastMessage,
      'senderUserDetails': instance.senderUserDetails,
      'chatDetails': instance.chatDetails,
      'roomId': instance.roomId,
      'chatType': instance.chatType,
      'deletedAt': instance.deletedAt,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

Details _$DetailsFromJson(Map<String, dynamic> json) => Details(
      userId: json['userId'] as String?,
      name: json['name'] as String?,
      profile: json['profile'] as String?,
    );

Map<String, dynamic> _$DetailsToJson(Details instance) => <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'profile': instance.profile,
    };

LastMessage _$LastMessageFromJson(Map<String, dynamic> json) => LastMessage(
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      message: json['message'] as String?,
      senderId: json['senderId'] as String?,
    );

Map<String, dynamic> _$LastMessageToJson(LastMessage instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'message': instance.message,
      'senderId': instance.senderId,
    };
