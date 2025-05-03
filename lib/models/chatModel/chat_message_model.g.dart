// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) =>
    ChatMessageModel(
      resData: json['resData'] == null
          ? null
          : ResData.fromJson(json['resData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) =>
    <String, dynamic>{
      'resData': instance.resData,
    };

ResData _$ResDataFromJson(Map<String, dynamic> json) => ResData(
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRecords: (json['totalRecords'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ResDataToJson(ResData instance) => <String, dynamic>{
      'messages': instance.messages,
      'totalRecords': instance.totalRecords,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      message: json['message'] as String?,
      sender: json['sender'] == null
          ? null
          : Sender.fromJson(json['sender'] as Map<String, dynamic>),
      msgType: json['msgType'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      messageId: json['messageId'] as String?,
      roomId: json['roomId'] as String?,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'message': instance.message,
      'sender': instance.sender,
      'msgType': instance.msgType,
      'mediaUrl': instance.mediaUrl,
      'messageId': instance.messageId,
      'roomId': instance.roomId,
    };

Sender _$SenderFromJson(Map<String, dynamic> json) => Sender(
      name: json['name'] as String?,
      profile: json['profile'] as String?,
      senderId: json['senderId'] as String?,
    );

Map<String, dynamic> _$SenderToJson(Sender instance) => <String, dynamic>{
      'name': instance.name,
      'profile': instance.profile,
      'senderId': instance.senderId,
    };
