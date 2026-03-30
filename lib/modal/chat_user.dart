class ChatUser {
  final String id;
  final String conversationId;
  final String name;
  final String subtitle;
  final String itemTitle;
  final String price;
  final String time;
  final bool isOnline;
  final int unreadCount;
  final int listingId;
  final String sellerId;
  final String buyerId;
  final String? photoUrl;
  final String? listingImage;

  ChatUser({
    required this.id,
    required this.conversationId,
    required this.name,
    required this.subtitle,
    required this.itemTitle,
    required this.price,
    required this.time,
    this.isOnline = false,
    this.unreadCount = 0,
    required this.listingId,
    required this.sellerId,
    required this.buyerId,
    this.photoUrl,
    this.listingImage,
  });

  factory ChatUser.fromConversation({
    required String id,
    required String conversationId,
    required String otherUserName,
    required String lastMessage,
    required String listingTitle,
    required double? listingPrice,
    required DateTime lastMessageTime,
    required int unreadCount,
    required int listingId,
    required String sellerId,
    required String buyerId,
    String? photoUrl,
    String? listingImage,
  }) {
    // Format time
    String timeStr;
    final now = DateTime.now();
    final diff = now.difference(lastMessageTime);

    if (diff.inMinutes < 1) {
      timeStr = 'Now';
    } else if (diff.inHours < 1) {
      timeStr = '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      timeStr = '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      timeStr = days[lastMessageTime.weekday % 7];
    } else {
      timeStr = '${lastMessageTime.day}/${lastMessageTime.month}';
    }

    return ChatUser(
      id: id,
      conversationId: conversationId,
      name: otherUserName,
      subtitle: lastMessage.isEmpty ? 'No messages yet' : lastMessage,
      itemTitle: listingTitle ?? 'Listing',
      price: listingPrice != null ? '\$$listingPrice' : '',
      time: timeStr,
      isOnline: false,
      unreadCount: unreadCount,
      listingId: listingId,
      sellerId: sellerId,
      buyerId: buyerId,
      photoUrl: photoUrl,
      listingImage: listingImage,
    );
  }

  ChatUser copyWith({
    String? id,
    String? conversationId,
    String? name,
    String? subtitle,
    String? itemTitle,
    String? price,
    String? time,
    bool? isOnline,
    int? unreadCount,
    int? listingId,
    String? sellerId,
    String? buyerId,
    String? photoUrl,
    String? listingImage,
  }) {
    return ChatUser(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      itemTitle: itemTitle ?? this.itemTitle,
      price: price ?? this.price,
      time: time ?? this.time,
      isOnline: isOnline ?? this.isOnline,
      unreadCount: unreadCount ?? this.unreadCount,
      listingId: listingId ?? this.listingId,
      sellerId: sellerId ?? this.sellerId,
      buyerId: buyerId ?? this.buyerId,
      photoUrl: photoUrl ?? this.photoUrl,
      listingImage: listingImage ?? this.listingImage,
    );
  }
}

class ChatMessage {
  final String id;
  final String text;
  final String time;
  final bool isMe;
  final DateTime timestamp;
  final bool isRead;
  final String senderId; // Store sender ID to recalculate isMe at runtime
  final String? imagePath; // Store local image path for display
  final String? imageUrl; // Store server image URL for display

  ChatMessage({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
    required this.timestamp,
    this.isRead = false,
    required this.senderId,
    this.imagePath,
    this.imageUrl,
  });

  factory ChatMessage.fromMessage({
    required String id,
    required String text,
    required DateTime timestamp,
    required bool isMe,
    bool isRead = false,
    required String senderId,
    String? imagePath,
    String? imageUrl,
  }) {
    // Format time
    String timeStr;
    if (isMe) {
      timeStr = '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      final now = DateTime.now();
      final diff = now.difference(timestamp);

      if (diff.inMinutes < 1) {
        timeStr = 'Now';
      } else if (diff.inHours < 1) {
        timeStr = '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        timeStr = '${diff.inHours}h ago';
      } else {
        timeStr =
            '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
      }
    }

    return ChatMessage(
      id: id,
      text: text,
      time: timeStr,
      isMe: isMe,
      timestamp: timestamp,
      isRead: isRead,
      senderId: senderId,
      imagePath: imagePath,
      imageUrl: imageUrl,
    );
  }

  // Create a copy with recalculated isMe based on current user
  ChatMessage copyWithRecalculatedIsMe(String currentUserId) {
    final newIsMe = senderId == currentUserId;
    return ChatMessage(
      id: id,
      text: text,
      time: newIsMe
          ? '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}'
          : time, // Keep original time format for received messages
      isMe: newIsMe,
      timestamp: timestamp,
      isRead: isRead,
      senderId: senderId,
      imagePath: imagePath,
      imageUrl: imageUrl,
    );
  }
}
