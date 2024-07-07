import 'package:flutter/foundation.dart';

class ChatBotMessageModel {
  final String role;
  final List<ChatPartModel> parts;

  const ChatBotMessageModel({
    required this.role,
    required this.parts,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is ChatBotMessageModel &&
              runtimeType == other.runtimeType &&
              role == other.role &&
              listEquals(parts, other.parts));

  @override
  int get hashCode => role.hashCode ^ parts.hashCode;

  @override
  String toString() {
    return 'ChatBotMessageModel{' + ' role: $role,' + ' parts: $parts,' + '}';
  }

  ChatBotMessageModel copyWith({
    String? role,
    List<ChatPartModel>? parts,
  }) {
    return ChatBotMessageModel(
      role: role ?? this.role,
      parts: parts ?? this.parts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'parts': parts.map((part) => part.toMap()).toList(),
    };
  }

  factory ChatBotMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatBotMessageModel(
      role: map['role'] as String,
      parts: List<ChatPartModel>.from(
          map['parts'].map((partMap) => ChatPartModel.fromMap(partMap))),
    );
  }
}

class ChatPartModel {
  final String text;

  const ChatPartModel({
    required this.text,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is ChatPartModel &&
              runtimeType == other.runtimeType &&
              text == other.text);

  @override
  int get hashCode => text.hashCode;

  @override
  String toString() {
    return 'ChatPartModel{' + ' text: $text,' + '}';
  }

  ChatPartModel copyWith({
    String? text,
  }) {
    return ChatPartModel(
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
    };
  }

  factory ChatPartModel.fromMap(Map<String, dynamic> map) {
    return ChatPartModel(
      text: map['text'] as String,
    );
  }
}
