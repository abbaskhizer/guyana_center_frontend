class ChatUser {
  final String name;
  final String subtitle;
  final String itemTitle;
  final String price;
  final String time;
  final bool isOnline;
  final int unreadCount;

  ChatUser({
    required this.name,
    required this.subtitle,
    required this.itemTitle,
    required this.price,
    required this.time,
    this.isOnline = false,
    this.unreadCount = 0,
  });
}

class ChatMessage {
  final String text;
  final String time;
  final bool isMe;

  ChatMessage({required this.text, required this.time, required this.isMe});
}
