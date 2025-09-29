import 'package:flutter/material.dart';

enum MessageType {
  sent,
  received,
}

class MessageModel {
  final int id;
  final String sender;
  final int senderId;
  final String text;
  final String type;
  final String status;
  final String imageUrl;
  final String fileUrl;
  final String? fileSize;
  final String timestamp;
  final bool isMine;

  MessageModel({
    required this.id,
    required this.sender,
    required this.senderId,
    required this.text,
    required this.type,
    required this.status,
    required this.imageUrl,
    required this.fileUrl,
    this.fileSize,
    required this.timestamp,
    required this.isMine,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? 0,
      sender: json['sender'] ?? '',
      senderId: json['sender_id'] ?? 0,
      text: json['text'] ?? '',
      type: json['type'] ?? 'text',
      status: json['status'] ?? 'sent',
      imageUrl: json['image_url'] ?? '',
      fileUrl: json['file_url'] ?? '',
      fileSize: json['file_size'],
      timestamp: json['timestamp'] ?? '',
      isMine: json['is_mine'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'sender_id': senderId,
      'text': text,
      'type': type,
      'status': status,
      'image_url': imageUrl,
      'file_url': fileUrl,
      'file_size': fileSize,
      'timestamp': timestamp,
      'is_mine': isMine,
    };
  }

  MessageModel copyWith({
    int? id,
    String? sender,
    int? senderId,
    String? text,
    String? type,
    String? status,
    String? imageUrl,
    String? fileUrl,
    String? fileSize,
    String? timestamp,
    bool? isMine,
  }) {
    return MessageModel(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      type: type ?? this.type,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      fileUrl: fileUrl ?? this.fileUrl,
      fileSize: fileSize ?? this.fileSize,
      timestamp: timestamp ?? this.timestamp,
      isMine: isMine ?? this.isMine,
    );
  }

  
  bool get isFromMe => isMine;
} 