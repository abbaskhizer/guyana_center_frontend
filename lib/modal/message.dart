class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      text: json['text'] ?? '',
      timestamp: json['timestamp'] != null
          ? (json['timestamp'] is DateTime
              ? json['timestamp']
              : DateTime.parse(json['timestamp']))
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
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
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}

class Conversation {
  final String id;
  final String conversationId;
  final int listingId;
  final String sellerId;
  final String buyerId;
  final String? listingTitle;
  final double? listingPrice;
  final DateTime lastMessageTime;
  final String? lastMessage;
  final int unreadCount;

  Conversation({
    required this.id,
    required this.conversationId,
    required this.listingId,
    required this.sellerId,
    required this.buyerId,
    this.listingTitle,
    this.listingPrice,
    required this.lastMessageTime,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      listingId: json['listingId'] ?? 0,
      sellerId: json['sellerId'] ?? '',
      buyerId: json['buyerId'] ?? '',
      listingTitle: json['listingTitle'],
      listingPrice: json['listingPrice'] != null
          ? double.tryParse(json['listingPrice'].toString())
          : null,
      lastMessageTime: json['lastMessageTime'] != null
          ? (json['lastMessageTime'] is DateTime
              ? json['lastMessageTime']
              : DateTime.parse(json['lastMessageTime']))
          : DateTime.now(),
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
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'lastMessage': lastMessage,
      'unreadCount': unreadCount,
    };
  }
}
