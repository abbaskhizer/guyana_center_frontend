import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guyana_center_frontend/modal/chat_user.dart';

class MessageStorageService {
  static final MessageStorageService _instance = MessageStorageService._internal();
  factory MessageStorageService() => _instance;
  MessageStorageService._internal();

  static const String _messagesKey = 'chat_messages';

  Future<void> saveMessages(String conversationId, List<ChatMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = messages.map((m) => {
      'id': m.id,
      'text': m.text,
      'timestamp': m.timestamp.toIso8601String(),
      'isMe': m.isMe,
      'isRead': m.isRead,
      'senderId': m.senderId,
      'imagePath': m.imagePath,
      'imageUrl': m.imageUrl,
    }).toList();

    final allMessages = await _getAllMessages();
    allMessages[conversationId] = messagesJson;
    await prefs.setString(_messagesKey, jsonEncode(allMessages));
  }

  Future<List<ChatMessage>> loadMessages(String conversationId) async {
    final allMessages = await _getAllMessages();
    final messagesJson = allMessages[conversationId];

    if (messagesJson == null) return [];

    return messagesJson.map<ChatMessage>((json) => ChatMessage.fromMessage(
      id: json['id'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      isMe: json['isMe'],
      isRead: json['isRead'],
      senderId: json['senderId'] ?? '',
      imagePath: json['imagePath'],
      imageUrl: json['imageUrl'],
    )).toList();
  }

  Future<void> clearConversationMessages(String conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    final allMessages = await _getAllMessages();
    allMessages.remove(conversationId);
    await prefs.setString(_messagesKey, jsonEncode(allMessages));
  }

  Future<void> clearAllMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_messagesKey);
  }

  Future<Map<String, dynamic>> _getAllMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_messagesKey);
    if (jsonString == null) return {};
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }
}
