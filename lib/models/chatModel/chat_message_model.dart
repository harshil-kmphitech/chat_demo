// To parse this JSON data, do
//
//     final chatMessageModel = chatMessageModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'chat_message_model.g.dart';

ChatMessageModel chatMessageModelFromJson(String str) => ChatMessageModel.fromJson(json.decode(str));

String chatMessageModelToJson(ChatMessageModel data) => json.encode(data.toJson());

@JsonSerializable()
class ChatMessageModel {
  final ResData? resData;

  ChatMessageModel({
    this.resData,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);
}

@JsonSerializable()
class ResData {
  final List<Message>? messages;
  final int? totalRecords;

  ResData({
    this.messages,
    this.totalRecords,
  });

  factory ResData.fromJson(Map<String, dynamic> json) => _$ResDataFromJson(json);

  Map<String, dynamic> toJson() => _$ResDataToJson(this);
}

@JsonSerializable()
class Message {
  final DateTime? createdAt;
  final String? message;
  final Sender? sender;
  final String? msgType;
  final String? mediaUrl;
  final String? messageId;
  final String? roomId;

  Message({
    this.createdAt,
    this.message,
    this.sender,
    this.msgType,
    this.mediaUrl,
    this.messageId,
    this.roomId,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable()
class Sender {
  final String? name;
  final String? profile;
  final String? senderId;

  Sender({
    this.name,
    this.profile,
    this.senderId,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => _$SenderFromJson(json);

  Map<String, dynamic> toJson() => _$SenderToJson(this);
}
