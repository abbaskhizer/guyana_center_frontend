import 'dart:convert';

class SocketMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final int? listingId;
  final String? imageUrl;

  SocketMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
    this.listingId,
    this.imageUrl,
  });

  static DateTime _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) {
      return value.isUtc ? value.toLocal() : value;
    }

    final parsed = DateTime.tryParse(value.toString());
    if (parsed == null) return DateTime.now();
    return parsed.isUtc ? parsed.toLocal() : parsed;
  }

  factory SocketMessage.fromJson(Map<String, dynamic> json) {
    return SocketMessage(
      id: json['id']?.toString() ?? '',
      conversationId: json['conversationId']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      receiverId: json['receiverId']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      timestamp: _parseTimestamp(json['timestamp']),
      isRead: json['isRead'] ?? false,
      listingId: json['listingId'] != null ? int.tryParse(json['listingId'].toString()) : null,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      if (listingId != null) 'listingId': listingId.toString(),
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}

class SocketConversation {
  final String id;
  final String conversationId;
  final int listingId;
  final String sellerId;
  final String buyerId;
  final String? listingTitle;
  final double? listingPrice;
  final List<String>? listingImages;
  final DateTime lastMessageTime;
  final String? lastMessage;
  final int unreadCount;

  SocketConversation({
    required this.id,
    required this.conversationId,
    required this.listingId,
    required this.sellerId,
    required this.buyerId,
    this.listingTitle,
    this.listingPrice,
    this.listingImages,
    required this.lastMessageTime,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory SocketConversation.fromJson(Map<String, dynamic> json) {
    // Handle both flat fields and nested objects from backend
    String sellerId, buyerId;
    
    if (json['seller'] is Map) {
      sellerId = json['seller']['id']?.toString() ?? '';
    } else {
      sellerId = json['sellerId']?.toString() ?? '';
    }
    
    if (json['buyer'] is Map) {
      buyerId = json['buyer']['id']?.toString() ?? '';
    } else {
      buyerId = json['buyerId']?.toString() ?? '';
    }
    
    return SocketConversation(
      id: json['id']?.toString() ?? '',
      conversationId: json['conversationId'] ?? '',
      listingId: json['listingId'] ?? 0,
      sellerId: sellerId,
      buyerId: buyerId,
      listingTitle: json['listingTitle'],
      listingPrice: json['listingPrice'] != null
          ? double.tryParse(json['listingPrice'].toString())
          : null,
      listingImages: json['listingImages'] != null
          ? (json['listingImages'] is String
              ? List<String>.from(jsonDecode(json['listingImages']))
              : List<String>.from(json['listingImages']))
          : null,
      lastMessageTime: SocketMessage._parseTimestamp(json['lastMessageTime']),
      lastMessage: json['lastMessage'],
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'listingId': listingId,
      'sellerId': sellerId,
      'buyerId': buyerId,
      'listingTitle': listingTitle,
      'listingPrice': listingPrice?.toString(),
      'listingImages': listingImages,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'lastMessage': lastMessage,
      'unreadCount': unreadCount,
    };
  }
}
